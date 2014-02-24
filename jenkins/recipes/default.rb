include_recipe 'jenkins::dependencies'
include_recipe 'nginx::service'
include_recipe 'jenkins::service'

directory '/var/lib/jenkins'

[:mount, :enable].each do |mount_action|
  mount '/var/lib/jenkins' do
    device '/vol/jenkins'
    fstype 'none'
    options 'bind,rw'
    action mount_action
  end
end

yum_package 'jenkins'

directory '/var/lib/jenkins/.ssh' do
  owner 'jenkins'
end

file '/var/lib/jenkins/.ssh/id_rsa' do
  owner 'jenkins'
  mode 0600
  content node[:jenkins][:ssh_key]
end

file '/var/lib/jenkins/.ssh/authorized_keys' do
  owner 'jenkins'
  mode 0600
  content node[:jenkins][:public_ssh_key]
end

file '/var/lib/jenkins/.ssh/config' do
  owner 'jenkins'
  mode 0600
  content 'StrictHostKeyChecking no'
  action :create_if_missing
end

cookbook_file '/etc/nginx/sites-available/jenkins' do
  source 'nginx-site'
  owner 'root'
  mode 0640
end

template '/var/lib/jenkins/config.xml' do
  source 'global.xml.erb'
  variables :environment_variables => {
    :access_key_id => node[:jenkins][:aws_credentials][:access_key_id],
    :secret_access_key=> node[:jenkins][:aws_credentials][:secret_access_key],
    :instance_id => node[:opsworks][:instance][:id]
  }
  owner 'jenkins'
  group 'jenkins'
  mode 0644
end

execute 'enable jenkins nginx site' do
  command 'nxensite jenkins'
  notifies :restart, resources(:service => 'nginx'), :immediately
end

execute 'disable default nginx site' do
  command 'nxdissite default'
  notifies :restart, resources(:service => 'nginx'), :immediately
  only_if do
    ::File.exists?('/etc/nginx/sites-enabled/default')
  end
end

directory '/var/lib/jenkins/updates' do
  owner 'jenkins'
end

remote_file '/var/lib/jenkins/updates/default.json' do
  source 'http://updates.jenkins-ci.org/update-center.json'
  owner 'jenkins'
end

execute 'Remove JS clutter from downloaded JSON' do
  command "sed -i'' -e '1d' /var/lib/jenkins/updates/default.json; sed -i'' -e '2d' /var/lib/jenkins/updates/default.json"
  notifies :restart, resources(:service => 'jenkins')
end

execute 'Wait for Jenkins to restart before installing plugins' do
  command 'sleep 15'
end

node[:jenkins][:plugins].each do |plugin|
  execute "Install jenkins plugin #{plugin}" do
    command "jenkins-cli -s http://localhost:80 install-plugin #{plugin}"
    notifies :restart, resources(:service => 'jenkins')
    creates "/var/lib/jenkins/plugins/#{plugin}.hpi"
  end
end

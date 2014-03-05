node[:deploy].each do |app, deploy|
  

  config_file = "/tmp/jenkins-config-#{app}.xml"

  template config_file do
    source 'job.xml.erb'
    variables :scm_url => deploy[:scm][:repository]
    owner 'jenkins'
    group 'jenkins'
    mode 0644
  end


  execute "create jenkins job for app #{app}" do
    command "java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:80 create-job #{app} < #{config_file}"
    creates "/var/lib/jenkins/jobs/#{app}"
  end
  
  file config_file do
    only_if { File.exists?(config_file) }
    action :delete
  end
end


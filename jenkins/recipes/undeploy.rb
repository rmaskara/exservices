execute 'change ec2 ruby softlink to /usr/local/bin version instead of /usr/bin' do
  command 'ln -fsn /etc/alternatives/ruby /usr/bin/ruby'
  user 'root'
end

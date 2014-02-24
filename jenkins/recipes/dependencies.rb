node[:jenkins][:dependencies][:gems].each do |gem_name|
  execute "/usr/local/bin/gem install --no-ri --no-rdoc #{gem_name}" 
end

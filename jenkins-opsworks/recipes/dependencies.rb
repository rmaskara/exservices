node[:jenkins][:dependencies][:gems].each do |gem_name|
  execute "/usr/local/bin/gem install --no-document #{gem_name}" 
end

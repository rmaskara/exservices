#node[:jenkins][:dependencies][:packages].each do |package_name, version|
  #package package_name do
     #version version
     #action :install
  #end
#end

node[:jenkins][:dependencies][:gems].each do |gem_name|
  execute "/usr/local/bin/gem install --no-ri --no-rdoc #{gem_name}" 
end

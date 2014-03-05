node[:jenkins][:dependencies][:gems].each do |gem_name|
  execute "executing gem" do
    "/usr/bin/gem install --no-ri --no-rdoc #{gem_name}" 
    not_if "/usr/bin/gem search --installed #{gem_name}"
  end
end

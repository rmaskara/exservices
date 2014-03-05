node[:jenkins][:dependencies][:gems].each do |gem_name|
  execute "executing gem" do
    "gem install --no-ri --no-rdoc #{gem_name}" 
    not_if "gem search --installed #{gem_name}"
  end
end

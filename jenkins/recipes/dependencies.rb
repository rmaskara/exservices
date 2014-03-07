node[:jenkins][:dependencies][:gems].each do |gem_name|
  execute "executing gem" do
    command "gem install --no-document #{gem_name}" 
    not_if "gem search --installed #{gem_name}"
  end
end

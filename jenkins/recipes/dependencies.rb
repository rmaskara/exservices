node[:jenkins][:dependencies][:gems].each do |gem_name|
  execute "executing gem" do
    "/usr/local/bin/gem install --no-document #{gem_name}" 
    not_if "/usr/local/bin/gem search --installed #{gem_name}"
  end
end

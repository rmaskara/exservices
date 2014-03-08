service 'jenkins init' do
  supports :restart => true
  action  [:enable, :start]
end


service 'jenkins' do
  supports :status => true, :restart => true, :reload => true
  action  [:enable, :start]
end

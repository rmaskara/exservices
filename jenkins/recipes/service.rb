service 'jenkins' do
  supports restart: true, reload: true
  action  [:enable, :start]
end

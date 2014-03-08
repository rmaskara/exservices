service 'jenkins' do
  supports restart: true
  action  [:enable, :start]
end

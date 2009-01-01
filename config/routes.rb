ActionController::Routing::Routes.draw do |map|
  map.root :controller=> "plans"
  map.connect '/all', :controller=>"plans", :action=>"all"
  map.resources :plans
  map.connect 'p/:date', :controller=>"plans", :action=>"index"
  map.connect 'p/:date/:time', :controller=>"plans", :action=>"index"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

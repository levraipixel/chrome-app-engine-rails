Rails.application.routes.draw do

  namespace 'chrome_app' do
    get 'version' => 'chrome_app#current_version', as: :version
    get 'updates' => 'chrome_app#updates', as: :updates
    get 'current' => 'chrome_app#latest', as: :current_version
    get 'v/:version' => 'chrome_app#by_version', as: :specific_version
  end

end
# Uncomment the next line to define a global platform for your project
platform :ios, '16.4'

target 'ios_bitcoin_hold' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Keychain
  pod 'KeychainSwift', '~> 19.0'

  target 'ios_bitcoin_holdTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ios_bitcoin_holdUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'KeychainSwift'
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.4'
      end
    end
  end
end

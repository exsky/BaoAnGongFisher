# Uncomment the next line to define a global platform for your project
platform :ios, '16.4' # set IPHONEOS_DEPLOYMENT_TARGET for the pods project
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

target 'BaoAnGongFisher' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for online member function
  pod 'Amplify'
  pod 'AmplifyPlugins/AWSCognitoAuthPlugin'
  pod 'AmplifyPlugins/AWSS3StoragePlugin'
  pod 'AmplifyPlugins/AWSDataStorePlugin'

  # The button
  pod 'BetterSegmentedControl', '~> 2.0'

  # Pods for BaoAnGongFisher

  # Marked 20230904
  # target 'BaoAnGongFisherTests' do
  #   inherit! :search_paths
  #   # Pods for testing
  # end

  # target 'BaoAnGongFisherUITests' do
  #   # Pods for testing
  # end

end

# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'cheer' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  #Sinch framework (SMS verify)
  pod ’SinchVerification-Swift’

  #Parse SDK
  pod 'Parse'

  # Pods for cheer
  pod 'SwiftyStarRatingView'
  #pod 'StarryStars', '~> 0.0.1'

  target 'cheerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'cheerUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

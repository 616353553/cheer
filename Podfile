# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'cheer' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  #Parse SDK
  pod 'Parse'

  #Firebase
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod ‘Firebase/Database’
  pod 'Firebase/Storage'

  # chat
  pod 'JSQMessagesViewController'

  # Pods for cheer
  pod 'Cosmos', '~> 9.0'
  #pod 'SwiftyStarRatingView'
  #pod 'StarryStars', '~> 0.0.1'

  # image picker
  pod "BSImagePicker", "~> 2.4"

  # circular progress bar
  pod 'KDCircularProgress'

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

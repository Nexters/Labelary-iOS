# Uncomment the next line to define a global platform for your project
platform :ios, '14.6'

target 'Fullstack' do
  use_frameworks!
  pod "SwiftUICardStack"
  pod 'OpenCombine', '~> 0.12.0'
  pod 'OpenCombineDispatch', '~> 0.12.0'
  pod 'OpenCombineFoundation', '~> 0.12.0'
  pod 'RealmSwift', '~> 10.5.1'
  pod 'lottie-ios'
  pod "Resolver"
  pod 'AlertToast'
  pod 'Rudder'
  pod "PostHog", "~> 1.1"
  pod 'AvoInspector'
  pod 'Firebase/Analytics'
target 'ShareSheet' do
  inherit! :search_paths
end
end
post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
  end
 end
end



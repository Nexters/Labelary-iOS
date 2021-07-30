# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'Fullstack' do
  pod "SwiftUICardStack"
  use_frameworks!
  pod 'OpenCombine', '~> 0.12.0'
  pod 'OpenCombineDispatch', '~> 0.12.0'
  pod 'OpenCombineFoundation', '~> 0.12.0'
  pod 'RealmSwift', '~> 10.5.1'
  pod 'ToastUI'
  pod 'lottie-ios'
  pod "Resolver"
  pod 'Firebase/Analytics'
   
post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
  end
 end
end

end


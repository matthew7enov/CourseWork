# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'CourseWork' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire'
  pod 'SVProgressHUD'
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestoreSwift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    # Fix issue with Xcode 14 where Resource Bundle targets require signing incorrectly
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end

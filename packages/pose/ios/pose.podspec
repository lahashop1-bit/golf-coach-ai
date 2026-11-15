#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint pose.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'pose'
  s.version          = '0.0.1'
  s.summary          = 'Golf Coach AI on-device pose estimation (MediaPipe Pose Landmarker).'
  s.description      = <<-DESC
Golf Coach AI on-device pose estimation (MediaPipe Pose Landmarker).
                       DESC
  s.homepage         = 'https://github.com/lahashop1-bit/golf-coach-ai'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Golf Coach AI' => 'dev@golfcoachai.invalid' }
  s.source           = { :path => '.' }
  s.source_files = 'pose/Sources/pose/**/*'
  s.dependency 'Flutter'
  s.dependency 'MediaPipeTasksVision'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 x86_64' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'pose_privacy' => ['pose/Sources/pose/PrivacyInfo.xcprivacy']}
end

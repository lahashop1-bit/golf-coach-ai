#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint capture.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'capture'
  s.version          = '0.0.1'
  s.summary          = 'Golf Coach AI native capture helpers.'
  s.description      = <<-DESC
Golf Coach AI native capture helpers.
                       DESC
  s.homepage         = 'https://github.com/lahashop1-bit/golf-coach-ai'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Golf Coach AI' => 'dev@golfcoachai.invalid' }
  s.source           = { :path => '.' }
  s.source_files = 'capture/Sources/capture/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'capture_privacy' => ['capture/Sources/capture/PrivacyInfo.xcprivacy']}
end

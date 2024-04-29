#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint rownd_flutter_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'rownd_flutter_plugin'
  s.version          = '1.0.0'
  s.summary          = 'Rownd bindings for Flutter on iOS'
  s.description      = <<-DESC
Provides access to Rownd APIs on iOS when using Flutter.
                       DESC
  s.homepage         = 'https://rownd.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rownd' => 'support@rownd.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  
  s.dependency 'Flutter'
  s.dependency 'Rownd', '~> 3.0.3'
  
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end

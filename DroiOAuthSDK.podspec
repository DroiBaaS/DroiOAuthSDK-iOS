Pod::Spec.new do |s|
s.name             = "DroiOAuthSDK"
s.version          = "0.0.5"
s.summary          = "卓易授权"
s.description      = "帮助开发者快速接入卓易账号"
s.homepage         = "https://github.com/DroiBaaS"
# s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author           = { "DoriBaaS" => "droiinfo@droi.com" }
s.source           = { :git => "https://github.com/DroiBaaS/DroiOAuthSDK-iOS.git", :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/NAME'

s.platform     = :ios, '8.0'

s.requires_arc = true

s.vendored_frameworks = "**/DroiOAuth.framework"
s.resources = "**/*.{png,xib}"
s.frameworks = 'Foundation', 'UIKit','JavaScriptCore','SystemConfiguration'
s.dependency 'DroiCoreSDK'
end
#
# Be sure to run `pod lib lint RYTransitioningDelegateSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RYTransitioningDelegateSwift'
  s.version          = '0.2.2'
  s.summary          = 'A viewController transition animation'

  s.homepage         = 'https://github.com/RisingSSR/RYTransitioningDelegateSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RisingSSR' => '2769119954@qq.com' }
  s.source           = { :git => 'https://github.com/RisingSSR/RYTransitioningDelegateSwift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  
  if s.respond_to? 'swift_version'
    s.swift_version = '4.8'
  end

  s.source_files = 'RYTransitioningDelegateSwift/Classes/**/*'
end

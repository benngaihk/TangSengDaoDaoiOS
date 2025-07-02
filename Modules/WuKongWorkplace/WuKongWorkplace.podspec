#
# Be sure to run `pod lib lint WuKongWorkplace.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WuKongWorkplace'
  s.version          = '0.1.0'
  s.summary          = '悟空IM工作台模块'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
悟空IM工作台模块，提供应用管理、分类管理、横幅管理等功能。
包含应用的添加、删除、排序，常用应用统计，应用分类浏览，以及工作台横幅展示等功能。
                       DESC

  s.homepage         = 'https://github.com/tangtaoit/WuKongWorkplace'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tangtaoit' => 'tt@wukong.ai' }
  s.source           = { :git => 'https://github.com/tangtaoit/WuKongWorkplace.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'WuKongWorkplace/Classes/**/*'
  
  s.resource_bundles = {
    'WuKongWorkplace_images' => ['WuKongWorkplace/Assets/Images.xcassets']
  }
  
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'WuKongBase'
  s.dependency 'PromiseKit/CorePromise', '~> 6.0'
  s.dependency 'Masonry'
  s.dependency 'SDWebImage','~> 5.9.1'
  s.dependency 'AFNetworking'
  
end 
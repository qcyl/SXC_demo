#
# Be sure to run `pod lib lint SSQ.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SSQ'
  s.version          = '0.0.1'
  s.summary          = 'A short description of SSQ.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://git.oschina.net/zykj135/SSQ'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '' => 'qichao@qczyl.club' }
  s.source           = { :git => 'https://git.oschina.net/zykj135/SSQ.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.subspec 'GX' do |ss|
        ss.source_files = 'SSQ/Classes/**/*'
  end

  s.subspec 'HLJ' do |ss|
        ss.source_files = 'SSQ/Classes/**/*'
  end

  s.subspec 'NX' do |ss|
        ss.source_files = 'SSQ/Classes/**/*'
  end

  s.subspec 'TJ' do |ss|
        ss.source_files = 'SSQ/Classes/**/*'
  end

  s.subspec 'ZJ' do |ss|
        ss.source_files = 'SSQ/Classes/**/*'
  end
  
  # s.resource_bundles = {
  #   'SSQ' => ['SSQ/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'QCRouter'
end

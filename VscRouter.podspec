Pod::Spec.new do |spec|
  spec.name             = 'VscRouter'
  spec.ios.deployment_target = '7.0'
  spec.version          = '1.0.0'
  spec.summary          = '按照URL规则做成的ios路由'

  spec.homepage         = 'https://github.com/vcsatanial/VscRouter'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'VincentSatanial' => '116359398@qq.com' }
  spec.source           = { :git => 'https://github.com/vcsatanial/VscRouter.git', :tag => spec.version }
  
  spec.source_files = 'VscRouter/*.{h,m}'
  spec.requires_arc = true
end

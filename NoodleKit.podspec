Pod::Spec.new do |s|
  s.name          = 'NoodleKit'
  s.version       = '0.0.1'
  s.license       = 'MIT'
  s.summary       = 'A random collection of Cocoa classes and categories'
  s.homepage      = 'http://www.noodlesoft.com/blog'
  s.authors       = { 'Paul Kim' => '' }
  s.source        = { :git => 'https://github.com/MrNoodle/NoodleKit.git' }
  s.source_files  = '*.{h,m}'
  s.clean_paths   = %w{English.lproj Examples NoodleKit.xcodeproj Info.plist README.md version.plist}
end

Pod::Spec.new do |s|
  s.name             = "DBEnvironmentConfiguration"
  s.version          = "0.1.3"
  s.summary          = "Easily switch between development environments/ configurations"
  s.description      = <<-DESC
Super-simple environment configuration for iOS apps. Switch between environments by changing one word.
                       DESC
  s.homepage         = "https://github.com/DavidBenko/DBEnvironmentConfiguration"
  s.license          = 'MIT'
  s.author           = { "David Benko" => "dbenko@prndl.us" }
  s.source           = { :git => "https://github.com/DavidBenko/DBEnvironmentConfiguration.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/davidwbenko'

  s.platform     = :ios
  s.requires_arc = true

  s.source_files = 'DBEnvironmentConfiguration/**/*.{h,m}'
end

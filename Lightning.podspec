Pod::Spec.new do |s|

  s.name         = "Lightning"
  s.version      = "1.0.2"
  s.summary      = "Lightning provides components to make Swift development easier."
  s.description  = <<-DESC
                    Lightning provides components to make Swift development easier. It
                    consists of helper  models and extensions that speed things up when
                    you are modeling your applications.
                   DESC
  s.homepage     = "https://github.com/gokselkoksal/Lightning/"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author           = { "Göksel Köksal" => "gokselkoksal@gmail.com" }
  s.social_media_url = "https://twitter.com/gokselkk"
  
  s.ios.deployment_target     = "8.0"
  s.osx.deployment_target     = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target    = "9.0"

  s.source       = { :git => "https://github.com/gokselkoksal/Lightning.git", :tag => "#{s.version}" }
  s.source_files = "Lightning/Sources", "Lightning/Sources/**/*.swift"

end

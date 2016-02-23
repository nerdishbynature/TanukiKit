Pod::Spec.new do |s|
  s.name             = "TanukiKit"
  s.version          = "0.5.1"
  s.summary          = "A Swift API Client for GitLab CE/EE"
  s.description      = <<-DESC
                        You are looking at the A Swift API Client for GitLabe CE/EE.
                        This is very unofficial and not maintained by GitLab.
                        DESC
  s.homepage         = "https://github.com/nerdishbynature/tanukikit"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Piet Brauer" => "piet@nerdishbynature.com" }
  s.source           = { :git => "https://github.com/nerdishbynature/tanukikit.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/pietbrauer"
  s.module_name     = "TanukiKit"
  s.dependency "NBNRequestKit", "~> 0.2.1"
  s.requires_arc = true
  s.source_files = "TanukiKit/*.swift"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
end

Pod::Spec.new do |spec|
  spec.name = "RaisrSDK"
  spec.version = "1.0.0"
  spec.summary = "Raisr SDK Project"
  spec.homepage = "http://raisr.org"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Nicky Thorne" => 'nicky.thorne@deliveryblueprints.com' }
  spec.platform = :ios, "9.1"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/jakecraige/RGB.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "RGB/**/*.{h,swift}"
  spec.dependency "Curry", "~> 1.4.0"
end

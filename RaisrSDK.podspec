Pod::Spec.new do |spec|
  spec.name = "RaisrSDK"
  spec.version = "1.0.1"
  spec.summary = "Raisr SDK Project"
  spec.homepage = "http://raisr.org"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Nicky Thorne" => 'nicky.thorne@deliveryblueprints.com' }
  spec.platform = :ios, "10.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/deliveryblueprints/raisr-ios-sdk.git", tag: 'v1.0.1' }
  spec.source_files = "raisr-ios-sdk/**/*.{h,swift}"
  spec.static_framework = true
  spec.swift_version = '5.0'
  spec.dependency "CMPComapiFoundation", "~> 2.0.1"
  spec.dependency "JWT"
  spec.dependency "JWTDecode"
  spec.dependency "Base64"
end

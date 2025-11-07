# Set a global platform high enough for all dependencies
platform :ios, '16.0'

use_frameworks!

target 'MyCorners' do
  # Google Maps & Places
  pod 'GoogleMaps', '~> 10.4'
  pod 'GooglePlaces', '~> 9.2'

  # Firebase
  pod 'FirebaseCore', '~> 10.29'
  pod 'FirebaseAuth', '~> 10.29'
  pod 'FirebaseFirestore', '~> 10.29'

  # Fix for Apple Silicon / Simulator issues
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings["$(inherited)"] = "$(inherited)"
    end

    # Apply exclusion to all pods targets
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
    end
  end
end
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Podcasts' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Networking
  pod 'Moya' # https://github.com/Moya/Moya
  pod 'AlamofireNetworkActivityIndicator' # https://github.com/Alamofire/AlamofireNetworkActivityIndicator
  pod 'SDWebImage' # https://github.com/SDWebImage/SDWebImage
  pod 'Kingfisher' # https://github.com/onevcat/Kingfisher
  pod 'FeedKit' # https://github.com/nmdias/FeedKit

  # UI
  pod 'SnapKit' # https://github.com/SnapKit/SnapKit
  pod 'SPStorkController' # https://github.com/IvanVorobei/SPStorkController

  # Persistence
  pod 'Disk' # https://github.com/saoudrizwan/Disk

  # Code quality
  pod 'R.swift' # https://github.com/mac-cain13/R.swift
#  pod 'SwiftLint' # https://github.com/realm/SwiftLint

end

# Cocoapods optimization, always clean project after pod updating
post_install do |installer|
  Dir.glob(installer.sandbox.target_support_files_root + "Pods-*/*.sh").each do |script|
    flag_name = File.basename(script, ".sh") + "-Installation-Flag"
    folder = "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
    file = File.join(folder, flag_name)
    content = File.read(script)
    content.gsub!(/set -e/, "set -e\nKG_FILE=\"#{file}\"\nif [ -f \"$KG_FILE\" ]; then exit 0; fi\nmkdir -p \"#{folder}\"\ntouch \"$KG_FILE\"")
    File.write(script, content)
  end

end

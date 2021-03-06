maintainer       "Ben Browning"
maintainer_email "ben324@gmail.com"
license          "Apache 2.0"
description      "Installs torquebox and sets it up as a runit service"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w{ubuntu debian}.each do |os|
  supports os
end

%w{java runit}.each do |cb|
  depends cb
end

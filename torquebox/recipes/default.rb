#
# Cookbook Name:: torquebox
# Recipe:: default
#
# Copyright 2010, Ben Browning
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "java"
package "unzip"

version = node[:torquebox][:version]
mirror = node[:torquebox][:mirror]

unless File.exists?("/opt/torquebox-#{version}-bin/jboss/bin/run.sh")
  remote_file "/tmp/torquebox-bin-#{version}.zip" do
    # source "#{mirror}/#{version}/torquebox-bin-#{version}.zip"
    source "torquebox-bin-#{version}.zip"
    mode "0644"
  end

  execute "unzip /tmp/torquebox-bin-#{version}.zip" do
    cwd "/opt"
  end

  directory "/opt/torquebox-#{version}-bin/jruby" do
    mode "0755"
  end

  link "/opt/torquebox-#{version}-bin/jruby/bin/ruby"  do
    to "/opt/torquebox-#{version}-bin/jruby/bin/jruby"
  end

  execute "chown -R vagrant:vagrant /opt/torquebox-#{version}-bin"

  execute %Q(echo "export TORQUEBOX_HOME=/opt/torquebox-#{version}-bin" >> ~vagrant/.bashrc)
  execute %Q(echo "export JBOSS_HOME=/opt/torquebox-#{version}-bin/jboss" >> ~vagrant/.bashrc)
  execute %Q(echo "export JRUBY_HOME=/opt/torquebox-#{version}-bin/jruby" >> ~vagrant/.bashrc)
  execute %Q(echo "export PATH=/opt/torquebox-#{version}-bin/jruby/bin:$PATH" >> ~vagrant/.bashrc)
end

runit_service "torquebox"

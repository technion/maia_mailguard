#!/usr/bin/env ruby
#
#  Created by David Morton on 2006-12-19.
#  Copyright (c) 2006. All rights reserved.  See LICENSE for license conditions.
#  This Rakefile is currently for testing purposes only.  It does not actually make or install Maia.


# import local configuration.  Copy rake_config.rb.dist to rake_config.rb and edit
require './rake_config.rb'

namespace :test do
  desc "Upload to test server"
  task :upload do
    sh %{ rsync -ave ssh --exclude="amavisd.conf" --exclude="config.php" --exclude=".git" ./ #{TESTHOST}:#{TESTHOST_PATH}}
  end
end

desc "Deploy to production server"
task :upload do
  sh %{ rsync -ave ssh --exclude="amavisd.conf" --exclude="config.php"  --exclude=".git" ./ #{DEPLOYHOST}:#{DEPLOYHOST_PATH}}
end

desc "Open the permissions on themes"
task :permissions do
  chmod 0777, Dir.glob('php/themes/*/compiled')
end
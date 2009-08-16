# This isn't currently very user friendly to people other than me.
# You need to be in the directory above the the folder containing this file.

# When you create your first user, to make them an admin:
# User.first.has_role!('admin')

# rails [app_name] -m rails_template/template.rb
# rails [app_name] -d mysql -m rails_template/template.rb

run "rm public/index.html"
run "rm public/robots.txt"

# Needed up here if you want to install gems as submodules
# I'm not right now...
git :init

# Make sure oid is above authlogic here, so it is below in the environment.rb
# I think this will change later in rails
plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git'
gem "authlogic-oid", :lib => "authlogic_openid"
gem 'authlogic'

gem 'mislav-will_paginate', :version => '~> 2.3.11', :lib => 'will_paginate'
gem 'haml'
gem 'be9-acl9', :lib => 'acl9'
gem 'josevalim-rails-footnotes',  :lib => 'rails-footnotes'
gem 'annotate'

# rake('gems:install', :sudo => true)
run "haml --rails ."

# git
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
file '.gitignore', %q{
.DS_Store
log
log/*
tmp/**/*
tmp
db/sphinx
db/sphinx/*
public/javascripts/all.js
public/stylesheets/all.js
db/*.sqlite3
}
# config/database.yml

FileUtils.cp_r "#{@root}/../rails_template/files/.", @root

run 'annotate -p after'

rake 'db:drop' # delete this later...
rake 'db:create'
rake 'open_id_authentication:db:create'
rake 'db:migrate'


git :add => '.'
git :commit => "-a -m 'Initial commit'"

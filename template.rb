# http://github.com/ericwright/rails-template/tree/master
# http://github.com/hectorsq/rails-templates/tree/master

  # cd .. && rm -rf testify && rails testify -d mysql -m kiwi_rails_template/template.rb && cd testify && script/server

# rails [app_name] -d mysql -m template.rb
# rails testify -d mysql -m kiwi_rails_template/template.rb

run "rm public/index.html"
run "rm public/robots.txt"

git :init # needed up here if you want to install gems as submodules

# http://github.com/mislav/will_paginate/tree/master
gem 'mislav-will_paginate', :version => '~> 2.3.11', :lib => 'will_paginate'
gem 'authlogic'
gem 'haml'
gem 'thoughtbot-paperclip', :lib => 'paperclip'
gem 'freelancing-god-thinking-sphinx', :lib => 'thinking_sphinx'
gem 'be9-acl9', :lib => 'acl9'
gem 'mbleigh-acts-as-taggable-on', :lib => 'acts-as-taggable-on'
gem 'josevalim-rails-footnotes',  :lib => 'rails-footnotes'
gem 'annotate'

# gem 'authlogic-oid', :lib => 'authlogic_openid'
# gem "ruby-openid", :lib => "openid"
# plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git'

# rake('gems:install', :sudo => true)
run "haml --rails #{@root}"

# git
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
file '.gitignore', %q{
.DS_Store
log
log/*
caches
tmp/**/*
tmp
db/sphinx
db/sphinx/*
public/javascripts/all.js
public/stylesheets/all.js
db/*.sqlite3
}
# config/database.yml

FileUtils.cp_r "#{@root}/../kiwi_rails_template/files/.", @root

run 'annotate -p after'
rake 'db:drop' # delete this later...
rake 'db:create'
rake 'db:migrate'

git :add => '.'
git :commit => "-a -m 'Initial commit'"

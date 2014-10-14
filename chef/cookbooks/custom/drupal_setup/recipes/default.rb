# directory "/var/www/foo" do
#   mode '0775'
#   action :create
# end

#git "/var/www/foo" do
#  repository "http://git.drupal.org/project/drupal.git"
#  revision "7.x"
#  action :sync
#end

log "Cleaning Drupal7 Directory and seting up Drupal.  May take a little while"
# bash "clean_dir_git_drupal" do
#   cwd "/var/www/drupal7"
#   code <<-EOH
#     echo "Changing permissions"
#     chmod -R 777 .
#     echo "Removing old files"
#     rm -Rf * .*
#     echo "Cloning Drupal7 repo"
#     git clone --branch 7.x http://git.drupal.org/project/drupal.git .
#     echo "Drush installing site"
#     drush @drupal7 si standard -y
#     echo "Running drush make file --no-core"
#     drush make /nidata/drupal7.make --no-core -y
#   EOH
# end

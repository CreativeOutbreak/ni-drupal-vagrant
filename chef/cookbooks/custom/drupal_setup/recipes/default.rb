directory "/var/www/foo" do
  mode '0775'
  action :create
end

#git "/var/www/foo" do
#  repository "http://git.drupal.org/project/drupal.git"
#  revision "7.x"
#  action :sync
#end


bash "clean_dir_git_drupal" do
  cwd "/var/www/drupal7"
  code <<-EOH
    chmod -R 777 .
    rm -Rf * .*
    git clone --branch 7.x http://git.drupal.org/project/drupal.git .
    drush @drupal7 si standard -y 
  EOH
end

cat nidata/cleanup.txt

echo "Changing permission on Drupal directory"
sudo chmod -R 777 data/drupal7

echo "remove all files from drupal7 directory"
#find data/drupal7 -mindepth 1 -exec rm -Rf {} \;
sudo rm -Rf data/drupal7
mkdir data/drupal7


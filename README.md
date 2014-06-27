## New Int Drupal dev with Vagrant & Chef
We've now setup our [Drupal][2] development enviroment using [Vagrant][1] & [Chef][3] for collaboration, demonstration and deployment reasons. We are using the [Vagrant Drupal Development (VDD)][9] preconfigured setup.
### Setting up and running
#### Cloning Repository
First thing to do is to browser to where you want to work on your local machine and clone this repo. Here is some example code for making a folder in your home directory call *ni_dev* and cloning this repo to there.
```shell
$ sudo mkdir ~/ni_dev
$ cd ~/ni_dev
$ sudo git clone https://github.com/CreativeOutbreak/ni-drupal-vagrant.git
```
If you don't have [git][4] installed, install it! ;)
Then run the previous code.
#### Setting up & running Vagrant
Now you've got your working directory set up, it's time to get the Vagrant server running.  
[Vagrant][6] uses [VirtualBox][5], so you need to download both of them to start with.  
You may also find the [Vagrant instalation page][7] and [getting started guid][8] helpfull.  Vagrant is verry well documented!

Now you've got them both install we'll move onto running the Vagrant box.

#### Running Vagrant
Fortunately, this couldn't really be simpler!  If you're not already in the working directory, browser to it `cd ~/ni_dev` and then run `vagrant up`. This may take a while the first time, as it need to download a linux box and then set it all up with the [Chef][3] config.  
NOTE: *Should take around 10 minutes, but may be longer if you have a slow connection.  It will tell you when it's done.*

### Setting up Drupal
[VDD][9] Doesn't include the Drupal files, as you'll probably want to pick your own flavour.  It is however very easy to get it setup.  
As you should now have a Vagrant server running, and are in the root of the working directory, you can ssh into the server using:
```
$ vagrant ssh
```
The [Chef config file][10] should of done most of the heavy lifting for you, including setting you [users & passwords][11]  
All you need to do now is setup the Drupal install of choice.  We're going to be using Drupal 8 & Drupal 7 (Spark).
You should alread of ssh'd into the Vagrant box, so now just run the following code to get Drupal 8 installed.
```
cd ~/sites/drupal8
git clone --branch 8.x http://git.drupal.org/project/drupal.git .
drush @drupal8 si standard -y
```




[1]: http://www.vagrantup.com/      "Vagrant - Main site"
[2]: https://www.drupal.org/       "Dupal - Main site"
[3]: http://www.getchef.com/         "Chef - Main site"
[4]: http://git-scm.com/            "Git - Main site"
[5]: https://www.virtualbox.org/wiki/Downloads      "VirtualBox - Download page"
[6]: http://www.vagrantup.com/downloads.html        "Vagrant - Dowload page"
[7]: http://docs.vagrantup.com/v2/installation/index.html       "Vagrant - Install page"
[8]: http://docs.vagrantup.com/v2/getting-started/index.html    "Vagrant - Getting started"
[9]: https://www.drupal.org/node/2008758                        "VDD - Documentation"
[10]: https://github.com/CreativeOutbreak/ni-drupal-vagrant/blob/master/config.json "Chef config - Default"
[11]: https://github.com/CreativeOutbreak/ni-drupal-vagrant/blob/master/config.json#L16-L38 "Chef - Drupal config"

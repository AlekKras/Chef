#!/bin/bash

update()
{
	sudo apt-get update
	sudo apt-get install curl -y
}

install_chef_dk()
{
	curl https://omnitruck.chef.io/install.sh | bash -s -- -P chefdk -c stable -v 2.5.3
}

additional()
{
	#instll vim and ...
	sudo apt-get install vim -y
	#customize it!!!
	git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
	sh ~/.vim_runtime/install_awesome_vimrc.sh
}


#update
install_chef_dk
additional
sudo apt autoremove -y

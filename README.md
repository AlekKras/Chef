# Chef

This repo is served as a reference to many cool projects with Chef.

I have created this when I found myself wondering how to actually configure all necessary materials.

## Installation

You would need Vagrant and VirtualBox for that. 

You can download:
  - Vagrant <a href="https://www.vagrantup.com/downloads.html">here</a>
  - VirtualBox <a href="https://www.virtualbox.org/wiki/Downloads">there</a>

Then you would need to create a folder and Vagrantfile with your box. I will use Ubuntu:

<code> cd Desktop && mkdir Ubuntu && cd Ubuntu/ && vim Vagrantfile </code>

You would need to copy paste the following:

```
Vagrant.configure("2") do |config|
  config.vm.box = "opscode_ubuntu-14.04"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"

  config.omnibus.chef_version = :latest
  config.vm.provision :chef_client do |chef|
    chef.provisioning_path = "/etc/chef"
    chef.chef_server_url = "https://api.opscode.com/organizations/bogotobogo-chef"
    chef.validation_key_path = "~/chef-repo/.chef/bogotobogo-chef-validator.pem"
    chef.validation_client_name = "bogotobogo-chef-validator"
    chef.node_name = "server"
  end
  config.vm.provider :virtualbox do |vb|
    vb.gui = false
  end
end
```
OR you can just do an alternative: Centos box and just install Chef inside.

```
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
end
```
Then you would run `vagrant up && vagrant ssh`

Inside the box, run the following:

<ul>
<li> `wget https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-12.0.3-1.x86_64.rpm` </li>
<li> `sudo yum localinstall https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-12.0.3-1.x86_64.rpm` </li>
</ul>


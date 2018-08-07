# Ubuntu

Typically, Chef is comprised of 3 parts - workstation, Chef server, and nodes.

![Example](https://learn.chef.io/assets/images/networks/workstation-server-node-08cb839d.png)

- Your *workstation* is the computer from which you author your cookbooks and administer your network.
It's typically the machine you use everyday. Although you'll be configuring Ubuntu, your workstation can be
any OS you choose – be it Linux, macOS, or Windows.
- Your *Chef server* acts as a central repository for your cookbooks as well as for information about every node
it manages. For example, the Chef server knows a node's fully qualified domain name (FQDN) and its platform.
- A *node* is any computer that is managed by a Chef server. Every node has the Chef client installed on it.
The Chef client talks to the Chef server. A node can be any physical or virtual machine in your network.

## Setup

##### Install [Chef DK](https://downloads.chef.io/chef-dk/)

##### Verify your Chef DK installation:

``` bash
chef --version
  Chef Development Kit Version: 2.5.3
  chef-client version: 13.8.5
  delivery version: master (73ebb72a6c42b3d2ff5370c476be800fee7e5427)
  berks version: 6.3.1
  kitchen version: 1.20.0
  inspec version: 1.51.21
```

##### Set up your text editor, either [Atom](http://atom.io/), [Visual Studio Code](https://code.visualstudio.com/),
[Sublime Text](http://www.sublimetext.com/) or a really great [Vim]( http://www.vim.org/) (I am biased though).

##### Create a working directory

``` bash
mkdir ~/learn_chef
cd ~/learn_chef
```

##### Install and Configure Git


Install it first:

``` bash
git --version
```

And surely, configure it:

``` bash
git config --global user.name "Chef"
git config --global user.email chef@chef.com
```

# Get set up with hosted Chef

## [Sign up for free tier access to hosted Chef](https://manage.chef.io/signup/)

After you sign up, you will receive an email. Just navigate to [https://manage.chef.io/login](https://manage.chef.io/login)

Do the following:

- Click *Create New Organization*
- Enter a full name and short name for your organization. An organization is typically a company name or a department within a company.
These names can be whatever you want but the short name must be unique
- Click *Create Organization*


## Configure your workstation

[knife](https://docs.chef.io/knife.html) s the command-line tool that provides an interface between your workstation and the Chef server.
`knife` enables you to upload your cookbooks to the Chef server and work with nodes, the servers that you manage.

`knife` requires two files to authenticate with the Chef Server:

- *RSA private key*

Every request to the Chef server is authenticated through an RSA public key pair. The Chef server holds the public part; you hold the private part.

- *knife configuration file*

The configuration file is typically named knife.rb. It contains information such as the Chef server's URL, the location of your RSA private key, and the default location of your cookbooks.

Both of these files are typically located in a directory named .chef. By default, every time knife runs, it looks in the current working directory for the .chef directory. If the .chef directory does not exist, knife searches up the directory tree for a .chef directory. This process is similar to how tools such as Git work.

One way to set up these files is to download what's called the starter kit from the web interface. The starter kit contains an RSA private key and knife configuration file. However, downloading the starter kit resets the keys for all users in your account. Here, you'll set up these files manually to see how the process works in a way that's safe for anyone on your team to repeat.

Create the `~/learn_chef/.chef` directory, You will add your RSA pruvarte key and `knife` configuration files in the next steps:

``` bash
mkdir ~/learn_chef/.chef
```
## Generate your knife configuration file

Here is how to create your `knife` configuration file. Your file will be added to `~/learn_chef/.chef/knife.rb`

- Sign in to [https://manage.chef.io/login](https://manage.chef.io/login)
- From the *administration* tab, select your organization
- From the menu on the left, select *Generate Knife Config* and save the file

From the command line, copy `knife.rb` to your `~/learn_chef/.chef`:

``` bash
cp ~/Downloads/knife.rb ~/learn_chef/.chef
```

Your `knife` configuration file should resemble this one:

``` ruby
# See http://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "chef-user-1"
client_key               "#{current_dir}/chef-user-1.pem"
chef_server_url          "https://api.chef.io/organizations/learn-chef-2"
cookbook_path            ["#{current_dir}/../cookbooks"]
```

## Geneate your RSA private key

To be added... use [this](https://learn.chef.io/modules/manage-a-node-chef-server/ubuntu/hosted/set-up-your-chef-server#/)

# Intro

Today we will learn the basics of Chef by using:


## Set up a virtual machine to manage

Ubuntu 16.04, Vagrant 2.0.4, VirtualBox 5.2.10r122088, Chef Development Kit 2.5.3

So as you see, you should install:

1) <a href="https://www.virtualbox.org/wiki/Downloads"> VirtualBox </a>

Verify the installation:

`VBoxManage --version`

If the command fails but you installed it anyways, that means that PATH is not configured right.

2) <a href="https://www.vagrantup.com/downloads.html"> Vagrant </a>

Verify the installation:

`vagrant --version`

If the command fails but you installed it anyways, that means that PATH is not configured right.

3) Ubuntu 14.04 Vagrant Box

`vagrant box add bento/ubuntu-14.04 --provider=virtualbox`

4) Bring it up

`vagrant init bento/ubuntu-14.04`

and then run:

`vagrant up`

and connect to the instance:

`vagrant ssh`

5) Install the Chef DK on Ubuntu

```
sudo apt-get update
sudo apt-get -y install curl
```

Next we should download Chef DK:

`curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 2.5.3`

6) Install VIM

`sudo apt-get install vim --yes`

7) Clean up

If you ever need to clean up, you can run

`vagrant destroy --force`


## Configure a resource

1) Set up a working directory

Let's create `chef-repo` under the home directory:

`mkdir ~/chef-repo`

and

`cd ~/chef-repo`

2) Create the MOTD file

Next, you'll write what's called a recipe to describe the desired state of the MOTD file. Then you'll run <a href="https://docs.chef.io/ctl_chef_client.html"<chef-client</a>, the program that applies your Chef code to place your system in the desired state. Typically, `chef-client` downloads and runs the latest Chef code from the Chef server, but in this module, you'll run `chef-client` in what's called local mode to apply Chef code that exists locally on your server.

Let's create a file `hello.rb` and add these contents:

```
file '/tmp/motd' do
  content 'hello world'
end
```
From the terminal, run the following command:

`chef-client --local-mode hello.rb`

You should see something like this as an output:

```
[2018-07-31T15:01:37+00:00] WARN: No config file found or specified on command line, using command line options.
[2018-07-31T15:01:37+00:00] WARN: No cookbooks directory found at or above current directory.  Assuming /home/vagrant/chef-repo.
Starting Chef Client, version 13.8.5
resolving cookbooks for run list: []
Synchronizing Cookbooks:
Installing Cookbook Gems:
Compiling Cookbooks...
[2018-07-31T15:01:39+00:00] WARN: Node vagrant-ubuntu-trusty-64 has an empty run list.
Converging 1 resources
Recipe: @recipe_files::/home/vagrant/chef-repo/hello.rb
  * file[/tmp/motd] action create
    - create new file /tmp/motd
    - update content in file /tmp/motd from none to b94d27
    --- /tmp/motd	2018-07-31 15:01:39.760079050 +0000
    +++ /tmp/.chef-motd20180731-1995-1agzaxj	2018-07-31 15:01:39.760079050 +0000
    @@ -1 +1,2 @@
    +hello world

Running handlers:
Running handlers complete
Chef Client finished, 1/1 resources updated in 01 seconds
[2018-07-31T15:01:39+00:00] WARN: No config file found or specified on command line, using command line options.
```

Basically, it tells us that a new file, `/tmp/motd` was created.

Let's verify that the file was written:

`more /tmp/motd`

Now let's run the command a second time:

`chef-client --local-mode hello.rb`

This time you get a different response.

3) Update the MOTD file's contents

Modify `hello.rb`:

```
file '/tmp/motd' do
  content 'hello chef'
end
```

And now run it again: `chef-client --local-mode hello.rb`

4) Ensure the MOTD file's contents are not changed by anyone else

Imagine that a co-worker manually changes `/tmp/motd` by replacing 'hello chef' with 'hello robots'. Go ahead and change your copy of `/tmp/motd` through your text editor. Or you can change the file from the command line like this.

`echo 'hello robots' > /tmp/motd`

And run `chef-client --local-mode hello.rb`

5) Delete the MOTD file

OK, you're done experimenting with the MOTD, so let's clean up. From your `~/chef-repo` directory, create a new file named `goodbye.rb` and save the following content to it:

```
file '/tmp/motd' do
  action :delete
end
```

Let's check:

`more /tmp/motd`

And it will say:

`/tmp/motd: No such file or directory`

## Configure a package and service

Let's try to manage the Apache HTTP Server package and its service

1) Ensure the apt cache is up to date

So we <i>could</i> run `apt-get update` manually. But over time, you would need
 to update `apt` cache to get the latest updates. Chef provides the <a href="https://docs.chef.io/resource_apt_update.html">apt_update</a> resource to automate it.

 From `~/chef-repo` add this code to file `webserver.rb`

 ```
 apt_update 'Update the apt cache daily' do
   frequency 86_400
   action :periodic
 end
 ```

 In a production environment, you might run Chef periodically to ensure your systems are kept up to date. As an example, you might run Chef multiple times in a day. However, you likely don't need to update the `apt` cache every time you run Chef. The `frequency` property specifies how often to update the `apt` cache (in seconds.) Here, we specify 86,400 seconds to update the cache once every 24 hours. (The _ notation is a Ruby convention that helps make numeric values more readable.)

The `:periodic` action means that the update occurs periodically. Another option would be to use the :update action to update the `apt` cache each time Chef runs.

 2) Install the Apache package

 Let's modify `webserver.rb`:

```
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'apache2'
```

We don't need to specify an action because `:install` is the default.

Now let's run `chef-client`:

`sudo chef-client --local-mode webserver.rb`

And run it again:

`sudo chef-client --local-mode webserver.rb`

3) Start and enable the Apache server

Let's first enable the Apache server when the server boots and then start the service. Modify `webserver.rb` to look like this:

```
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'apache2'

service 'apache2' do
  supports status: true
  action [:enable, :start]
end
```

And let's apply it:

`sudo chef-client --local-mode webserver.rb`

4) Add a home page

Append `file` to `/var/www/html/index.html`:

```
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'apache2'

service 'apache2' do
  supports status: true
  action [:enable, :start]
end

file '/var/www/html/index.html' do
  content '<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>'
end
```

Now apply it:

`sudo chef-client --local-mode webserver.rb`

5) Confirm your web site is runnning

`curl localhost`

This is what you should see:

```
<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>
```

## Make your Recipe more manageable

Let's create a cookbook to make our web server recipe easier to manage

1) Create a cookbook

First, from `~/chef-repo` create the `cookbooks` directory:

`mkdir cookbooks`

Now run the following:

`chef generate cookbook cookbooks/learn_chef_apache2`

Installation has been taken place and now you have `learn_chef_apache2`

Run the following to see the structure:

`sudo apt-get install tree && tree cookbooks`

You should be able to see something like this:

```
cookbooks
└── learn_chef_apache2
    ├── Berksfile
    ├── chefignore
    ├── LICENSE
    ├── metadata.rb
    ├── README.md
    ├── recipes
    │   └── default.rb
    ├── spec
    │   ├── spec_helper.rb
    │   └── unit
    │       └── recipes
    │           └── default_spec.rb
    └── test
        └── integration
            └── default
                └── default_test.rb

8 directories, 9 files
```

2) Create a template

Let's generate the HTML file for our home page

`chef generate template cookbooks/learn_chef_apache2 index.html`

You should see something like this:

```
Recipe: code_generator::template
  * directory[cookbooks/learn_chef_apache2/templates] action create
    - create new directory cookbooks/learn_chef_apache2/templates
  * template[cookbooks/learn_chef_apache2/templates/index.html.erb] action create
    - create new file cookbooks/learn_chef_apache2/templates/index.html.erb
    - update content in file cookbooks/learn_chef_apache2/templates/index.html.erb from none to e3b0c4
    (diff output suppressed by config)
```

The file `index.html.erb` gets created under `learn_chef_apache2/templates`

Now copy the contents of the HTML file from the recipe to the new HTML file at
`~/chef-repo/cookbooks/learn_chef_apache2/templates`

3) Update the recipe to referebce the HTML template

Let's write the recipe `default.rb` at `~/chef-repo/cookbooks/learn_chef_apache2/recipes/`

```
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'apache2'

service 'apache2' do
  supports status: true
  action [:enable, :start]
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end
```

4) Run the cookbook

Let's run it!

`sudo chef-client --local-mode --runlist 'recipe[learn_chef_apache2]'`

And check if a web page is still available:

`curl localhost`

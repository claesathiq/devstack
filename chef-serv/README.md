cher-serv Cookbook
===============
This cookbook installs Chef Server on Amazon OpsWorks using the Omnibus installer

It really down nothing but calls OpsCode's chef-server recipe



Machine setup
-------------

Create a volume for storing data, see the section on backup

In Vagrant with Virtualbox, do:

    disk_file = './tmp/large_disk.vdi'
    
    config.vm.provider "virtualbox" do | v |
        unless File.exist?(disk_file)
            v.customize ['createhd', '--filename', disk_file, '--size', 500 * 1024]
            config.vm.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk_file]
            config.vm.provision "shell", inline: 'sudo mkfs.ext4 /dev/xvdf'
        else
            config.vm.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk_file]
        end
    end

Nicer pattern for inline scripts:

    $script = <<SCRIPT
    sudo mkfs.ext4 /dev/xvdf
    SCRIPT
    
    config.vm.provision "shell", inline: $script


In a regular box, such as on EC2, the above Virtualbox commands, would simply be:

    sudo mkfs.ext4 /dev/xvdf
    
    sudo mkdir -m 000 /vol
    echo "/dev/xvdf /vol auto noatime 0 0" | sudo tee -a /etc/fstab
    sudo mount /vol



Default account
---------------
On first install, the default login is:


	`user: admin`
	`password: p@ssw0rd1`


Debian package
--------------

`https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.12-1.ubuntu.12.04_amd64.deb`


Configuration
-------------


in '/etc/chef-server/chef-server.rb' set:

	bookshelf['data_dir']	= '/data/chef'
	postgresql['data_dir']	= '/data/posgresql'
	nginx['enable_non_ssl'] = true

	chef-server-ctl reconfigure



Add separate data volume for git repos
---------------------------------------

Attach new EBS volume to /dev/sdf to act as data volume

    mkfs.ext4 /dev/xvdf
    mkdir -m 000 /data
    echo "/dev/xvdf /data auto noatime 0 0" | tee -a /etc/fstab
    mount /data
    mkdir /data/chef
    mkdir /data/posgresql
    # creates /data/chef

After installing chef-server

    chown chef_server:chef_server /data/chef
    chmod 0700 /data/chef
    chown opscode-pgsql:opscode-pgsql /data/posgresql
    chmod 0700 /data/posgresql

Configure Chef Server to use data area:

in '/etc/chef-server/chef-server.rb' set

	bookshelf['data_dir']	= '/data/chef'
	postgresql['data_dir']	= '/data/posgresql'
	nginx['enable_non_ssl'] = true


Add separate data volume for backup
---------------------------------------

Attach new EBS volume to /dev/sdg to act as data volume

    mkfs.ext4 /dev/xvdg
    
    mkdir -m 000 /backup
    echo "/dev/xvdg /backup auto noatime 0 0" | tee -a /etc/fstab
    mount /backup
    mkdir /backup/chef
    # creates /backup/chef

See section on Backup for information about running backups


Backup
------

Back up everything in

	/etc/chef-server
	/var/opt/chef-server/bookshelf/data
	# PostgreSQL db

This suggests that adding a volume at '/data' changing the following settings to point to the new volume will make life easier

	bookshelf['data_dir']	= '/data/chef'
	postgresql['data_dir']	= '/data/posgresql'


and maybe also solr, although this can be re-created using: chef-server-ctl reindex

    chef_solr['data_dir']	= '/data/solr'

After any change in settings, run:

    chef-server-ctl reconfigure

Usage
-----
###chef-serv::default
Just include `chef-serv` in your node's `run_list`:

    {
        "run_list": ["recipe[haproxy::default]"],
        "chef-server": {
            "api_fqdn": "chef.localhost.com"
            "nginx": {
                "enable_non_ssl": "true"
            }
        }
    }

License and Authors
-------------------
Authors: Claes Jonsson claes.jonsson@assaabloy.com

# -*- mode: ruby -*-
# vi: set ft=ruby :

# You can ask for more memory and cores when creating your Vagrant machine:
# GITLAB_VAGRANT_MEMORY=2048 GITLAB_VAGRANT_CORES=4 vagrant up
MEMORY = ENV['GITLAB_VAGRANT_MEMORY'] || '1536'
CORES = ENV['GITLAB_VAGRANT_CORES'] || '2'


# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box     = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

   config.vm.network :forwarded_port, guest: 3000, host: 3000
   config.vm.network :forwarded_port, guest: 80, host: 8000

   config.vm.network :private_network, ip: "192.168.3.20"
   
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider :virtualbox do |vb|
    vb.name = "is_devstack_gitlab"
    vb.customize ["modifyvm", :id, "--memory", MEMORY.to_i]
    vb.customize ["modifyvm", :id, "--cpus", CORES.to_i]

    if CORES.to_i > 1
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
    end
  end

  # Note:
  # Using version "11.10" because that is the latest version
  # AWS OpsWorks supports, and its support search like a chef server
  config.omnibus.chef_version = "11.10.4-1"

   # Enabling the Berkshelf plugin. To enable this globally, add this configuration
   # option to your ~/.vagrant.d/Vagrantfile file
   config.berkshelf.enabled = true

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = ["site-cookbooks", "cookbooks"]
    chef.roles_path = "roles"
    chef.data_bags_path = "data_bags"

    chef.run_list = ["gitlab::default"]

    chef.json = {
      gitlab: {
        domain: "localhost.com",
        hostname: "git"
      }
    }
  end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end

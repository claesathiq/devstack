# -*- mode: ruby -*-
# vi: set ft=ruby :

def deep_merge(source_hash, new_hash)
  source_hash.merge(new_hash) do |key, old, new|
    if new.respond_to?(:blank) && new.blank?
      old
    elsif (old.kind_of?(Hash) and new.kind_of?(Hash))
      deep_merge(old, new)
    elsif (old.kind_of?(Array) and new.kind_of?(Array))
      old.concat(new).uniq
    else
      new
    end
  end
end


# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |global_config|

  NODES_JSON = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'nodes.json').read)
  # 'mysql' passwords are automatically generated in client mode, see also about using app_lb recipe for 'haproxy'
  COMMON_JSON = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'common.json').read)

  NODES_JSON.each_pair do |name, options|

    if options.delete('enabled')

      global_config.vm.define name do |config|

        config.vm.box = options.delete('box') || "precise64"
        config.vm.box_url = options.delete('box_url') || "http://files.vagrantup.com/precise64.box"

        config.vm.provider :virtualbox do |vb|
          vb.name = "vagrant_#{name}"
          vb.customize ["modifyvm", :id, "--memory", options.delete('box_memory') || 512]

          cores = options.delete('box_cores') || 1
          vb.customize ["modifyvm", :id, "--cpus", cores]

          if cores > 1
            vb.customize ["modifyvm", :id, "--ioapic", "on"]
          end
        end

        config.vm.network :private_network, ip: options.delete('public_ip')
        config.vm.hostname = options.delete('hostname')

        # Detects vagrant-omnibus plugin
        if Vagrant.has_plugin?('vagrant-omnibus')
          # Using version "11.10" because that is the latest version
          # AWS OpsWorks supports, and it supports search like a chef server
          config.omnibus.chef_version = "11.10.4"
        else
          puts "FATAL: Vagrant-omnibus plugin not detected. Please install the plugin with\n       'vagrant plugin install vagrant-omnibus' from any other directory\n       before continuing."
          exit
        end

        # Detects vagrant-berkshelf plugin
        if Vagrant.has_plugin?('berkshelf')
          # The path to the Berksfile to use with Vagrant Berkshelf
          # config.berkshelf.berksfile_path = './Berksfile'

          # Enabling the Berkshelf plugin. To enable this globally, add this configuration
          # option to your ~/.vagrant.d/Vagrantfile file
          config.berkshelf.enabled = true
        else
          puts "FATAL: Vagrant-berkshelf plugin not detected. Please install the plugin with\n       'vagrant plugin install vagrant-berkshelf' from any other directory\n       before continuing."
          exit
        end



        # Share an additional folder to the guest VM. The first argument is
        # the path on the host to the actual folder. The second argument is
        # the path on the guest to mount the folder. And the optional third
        # argument is a set of non-required options.
        # config.vm.synced_folder "../data", "/vagrant_data"

        config.vm.provision "chef_solo" do |chef|

          roles = options.delete('roles') || []
          roles.each do |role|
            chef.add_role(role)
          end

          chef.run_list = options.delete('run_list')

          cjson = deep_merge(COMMON_JSON, options)
          # puts(JSON.pretty_generate(cjson))
          chef.json = cjson

        end  #end chef

      end #end define

    end #end if enabled

  end #end each_pair

end

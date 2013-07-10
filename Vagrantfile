# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

vms = YAML.load_file "vagrantvms.yml"

Vagrant.configure("2") do |config|
  vms.each do |name, values|
    config.vm.define name.to_sym do |vm_config|
      vm_config.vm.box = values['box']
      vm_config.vm.box_url = values['box_url']
      # vm_config.vm.host_name = "yagm-#{name}"
    end
  end
  config.vm.synced_folder '.', '/vagrant', disabled: true
end

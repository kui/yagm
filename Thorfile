# encoding: utf-8

require 'bundler'
require 'bundler/setup'
require 'berkshelf/thor'
require 'yaml'

class Default < Thor
  include Thor::Actions
  default_task :all

  VMS = YAML.load_file "vagrantvms.yml"

  desc 'vagrant-up [VM_NAME_REGEX]', 'exec `vagrant up [VM_NAME]\''
  def vagrant_up(regex='')
    vms_matched_with(regex).each do |name|
      run 'vagrant up' + (name ? " #{name}" : '')
    end
  end

  desc 'vagrant-destroy [VM_NAME_REGEX]', 'exec `vagrant destroy --force [VM_NAME]\''
  def vagrant_destroy(regex='')
    vms_matched_with(regex).each do |name|
        run 'vagrant destroy --force' + (name ? " #{name}" : '')
    end
  end

  desc 'integration-test [VM_NAME_REGEX]', 'test for multiple-platform with vagrant'
  def integration_test(regex='')
    invoke :vagrant_up, [regex]
    invoke :vagrant_destroy, [regex]
  end

  desc 'vm-list', 'list vm names managed by vagrant'
  def vm_list
    puts VMS.keys
  end

  no_commands do
    def vms_matched_with(regex='')
      VMS.keys.delete_if do |n|
        n.match(Regexp.new(regex)).nil?
      end
    end
  end
end

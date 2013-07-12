# encoding: utf-8

require 'bundler'
require 'bundler/setup'
require 'berkshelf/thor'
require 'yaml'

class Default < Thor
  include Thor::Actions

  VMS = YAML.load_file "vagrantvms.yml"

  desc 'vagrant-up [VM_NAME_REGEX]', 'exec `vagrant up [VM_NAME]\''
  def vagrant_up(regex='')
    vms_matched_with(regex).each do |name|
      run "vagrant up #{name}" and
        run "vagrant ssh-config #{name} > #{ssh_config name}"
    end.reduce(true){|memo, value| memo and value}
  end

  desc 'vagrant-destroy [VM_NAME_REGEX]', 'exec `vagrant destroy --force [VM_NAME]\''
  def vagrant_destroy(regex='')
    vms_matched_with(regex).each do |name|
      run "vagrant destroy --force #{name}" and
        run "rm #{ssh_config name}" if File.file? ssh_config name
    end.reduce(true){|memo, value| memo and value}
  end

  desc 'integration-test VM_NAME_REGEX', 'test for multiple-platform with vagrant'
  def integration_test(regex)
    vms_matched_with(regex).each do |name|
      invoke :vagrant_up, ["^#{name}$"] and
        invoke :bootstrap, ["^#{name}$"] and
        invoke :rspec, ["^#{name}$"] and
        invoke :vagrant_destroy, ["^#{name}$"]
    end
  end

  desc 'bootstrap [VM_NAME_REGEX]', 'exec `knif solo bootstrap HOSTNAME`'
  def bootstrap(regex='')
    vms_matched_with(regex).map do |name|
      run "bundle exec knife solo bootstrap #{name} -F #{ssh_config name}"
    end.reduce(true){|memo, value| memo and value}
  end

  desc 'cook [VM_NAME_REGEX]', 'exec `knif cook prepare HOSTNAME`'
  def cook(regex='')
    vms_matched_with(regex).map do |name|
      run "bundle exec berks install" and
        run "bundle exec knife solo cook #{name} -F #{ssh_config name}"
    end.reduce(true){|memo, value| memo and value}
  end

  desc 'rspec [VM_NAME_REGEX]', 'exec `rspec`'
  def rspec(regex='')
    result = vms_matched_with(regex).each do |name|
      ENV['SPEC_SSH_CONFIG'] = ssh_config name
      ENV['TARGET_HOST'] = name
      run "rspec spec"
    end.reduce(true){|memo, value| memo and value}

    ENV.delete 'SPEC_SSH_CONFIG'
    ENV.delete 'TARGET_HOST'
    result
  end

  desc 'vm-list', 'list vm names managed by vagrant'
  def vm_list
    puts VMS.keys
  end

  no_commands do
    def vms_matched_with(regex='')
      vms = VMS.keys.delete_if do |n|
        n.match(Regexp.new(regex)).nil?
      end
      if vms.empty?
        abort "No VMs matched with regex(/#{regex}/)"
      else
        vms
      end
    end
    def ssh_config(name)
      ".vagrant/#{name}.ssh_config"
    end
  end
end

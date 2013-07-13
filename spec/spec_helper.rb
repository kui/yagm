require 'serverspec'
require 'pathname'
require 'net/ssh'

include Serverspec::Helper::Ssh
include Serverspec::Helper::DetectOS

SSH_CONFIG_FILE = "SPEC_SSH_CONFIG"

RSpec.configure do |c|
  if ENV['ASK_SUDO_PASSWORD']
    require 'highline/import'
    c.sudo_password = ask("Enter sudo password: ") { |q| q.echo = false }
  else
    c.sudo_password = ENV['SUDO_PASSWORD']
  end
  c.before :all do
    host = ENV['TARGET_HOST']
    if host.nil?
      block = self.class.metadata[:example_group_block]
      if RUBY_VERSION.start_with?('1.8')
        file = block.to_s.match(/.*@(.*):[0-9]+>/)[1]
      else
        file = block.source_location.first
      end
      host  = File.basename(Pathname.new(file).dirname)
    end
    if c.host != host
      c.ssh.close if c.ssh
      c.host  = host
      options =
        if ENV[SSH_CONFIG_FILE]
          Net::SSH::Config.for(c.host, [ENV[SSH_CONFIG_FILE]])
        else
          Net::SSH::Config.for(c.host)
        end
      user    = options[:user] || Etc.getlogin

      c.ssh   = Net::SSH.start(c.host, user, options)
    end
  end
end

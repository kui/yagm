#
# Cookbook Name:: yagm
# Recipe:: default
#
# Copyright (C) 2013 Keiichiro UI
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'hostname'
include_recipe 'selinux::disabled'
include_recipe 'postfix-dovecot'

postfixadmin_admin 'admin@admindomain.com' do
  password 'foobarbaz'
  action :create
end

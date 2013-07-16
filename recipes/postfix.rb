#
# Cookbook Name:: yagm
# Recipe:: postfix
#
# Copyright (C) 2013 Keiichiro UI
#
# All rights reserved - Do Not Redistribute
#

%w(
postfix
sasl2-bin
libsasl2-2
libsasl2-modules
).each do |pkg_name|
  package pkg_name
end

%w(
/etc/postfix/main.cf
/etc/postfix/master.cf
).each do |file|
  template file do
    source "#{file[1..-1]}.erb"
    owner 'root'
    group 'root'
    mode 00644
  end
end

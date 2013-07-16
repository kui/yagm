default[:set_fqdn] = 'mail.foo.com'
default['postfix-dovecot']['postmaster_address'] = 'postmaster@foo.com'

mysql_password = 'asdfghjkl'
%w(
server_root_password
server_repl_password
server_debian_password
).each do |k| default['mysql'][k] = mysql_password end

default['postfixadmin']['database']['password'] = mysql_password
default['postfixadmin']['setup_password'] = 'hogefuga'
default['postfixadmin']['setup_password_salt'] = 'keiichiroui'

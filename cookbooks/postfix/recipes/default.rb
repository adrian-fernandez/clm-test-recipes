#
# Cookbook Name:: postfix
# Recipe:: default
#
# Configuration settings

if ['app_master', 'solo'].include?(node[:instance_role])
  package "mail-mta/ssmtp" do
    action :remove
    ignore_failure true
  end

  package "mail-mta/postfix" do
    action :install
  end

  service "postfix" do
    supports :status => true, :restart => true, :reload => true
  end

  %w{master.cf leadalead-domains leadalead-transports sasl_passwd.db}.each do |cfg|
    remote_file "/etc/postfix/#{cfg}" do
      source cfg
      owner "root"
      group 0
      mode 00644
      notifies :reload, resources(:service => "postfix")
    end
  end

  template "/etc/postfix/main.cf" do
    source "main.cf.erb"
    owner "root"
    group 0
    mode 00644
    variables({ :proxy_interfaces => "23.21.243.56", :mydomain => "leadalead.com" })
    notifies :reload, resources(:service => "postfix")
  end

  remote_file "/etc/aliases" do
    source "aliases"
    owner "root"
    group 0
    mode 00644
  end

  execute "Generate /etc/postfix/leadalead-transports.db" do
    command "/usr/sbin/postmap /etc/postfix/leadalead-transports"
  end

  execute "Generate /etc/aliases.db" do
    command "/usr/sbin/postalias /etc/aliases"
  end

  service "postfix" do
    action :start
  end
end

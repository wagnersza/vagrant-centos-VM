# Class: puppetmaster::common
#
# Puppet master commun class
#
# Author: Wagner Souza (wagnersza@corp.globo.com)
#
class puppetmaster::common {

	#Variables:
	$project = puppetmaster
	$appuser = puppet
	$appgroup = puppet
		
	# Repo files
	file { 'prosvc.repo':
		path => '/etc/yum.repos.d/prosvc.repo',
		ensure => present,
		content => template("$project/prosvc.repo.erb"),
		owner => 'root',
	}
	file { 'puppetlabs.repo':
		path => '/etc/yum.repos.d/puppetlabs.repo',
		ensure => present,
		content => template("$project/puppetlabs.repo.erb"),
		owner => 'root',
	}
	file { 'rpmforge.repo':
		path => '/etc/yum.repos.d/rpmforge.repo',
		ensure => present,
		content => template("$project/rpmforge.repo.erb"),
		owner => 'root',
	}
	file { 'epel.repo':
		path => '/etc/yum.repos.d/epel.repo',
		ensure => present,
		content => template("$project/epel.repo.erb"),
		owner => 'root',
	}
	
	# RPMS
	package {'puppet':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		# ensure => '2.6.7-0.5.noarch';
		ensure => 'latest';
	'puppet-server':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		# ensure => '2.6.7-0.5.noarch';
		ensure => 'latest';
	'puppet-dashboard':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		# ensure => '1.1.0-1.noarch';
		ensure => 'latest';		
	'ruby':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		# ensure => '1.8.5-5.el5_4.8';
		ensure => 'latest';
	'rubygems':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		# ensure => '1.3.1-1.el5';
		ensure => 'latest';
	'rubygem-rails':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		# ensure => '2.1.1-2.el5';
		ensure => 'latest';
	'rubygem-sqlite3-ruby':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		# ensure => '1.2.4-1.el5';
		ensure => 'latest';
	'ruby-devel':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		# ensure => '1.8.5-5.el5_4.8';
		ensure => 'latest';
	'ruby-mysql':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		# ensure => '2.7.3-1.el5';
		ensure => 'latest';
	'mysql-server':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		# ensure => '5.0.77-4.el5_6.6';			
		ensure => 'latest';
	}
	
	# Start and install mysql service
	service	{ 'mysqld':
		ensure => running,
		enable => true,
	}
	
	# rake DB migrate
	exec { "db-migrate":
			require => [ Package["mysql-server"], Package["puppet-dashboard"] ],
			environment => ['RAILS_ENV=production'],
			command => "sh -c 'cd /usr/share/puppet-dashboard && rake install && rake db:create && rake db:migrate'";
	}

	# Create report dir	
	exec {"mkdir-reports":
			require => [ Package["puppet-dashboard"] ],
			command => "mkdir -p /var/lib/puppet/lib/puppet/reports/";
	}
		
	#Change puppet config files
	file { '/etc/sysconfig/puppet':
		ensure => present,
		content => template("$project/puppet_sysconfig.erb");
	'/etc/sysconfig/puppetmaster':
		ensure => present,
		content => template("$project/puppetmaster-sysconfig.erb");
	'/etc/puppet/puppet.conf':
		ensure => present,
		content => template("$project/puppet-conf.erb");	
	'/var/lib/puppet/lib/puppet/reports/puppet_dashboard.rb':
		require => Exec["mkdir-reports"],
		ensure => present,
		content => template("$project/puppet_dashboard.rb.erb");
	}
	
}
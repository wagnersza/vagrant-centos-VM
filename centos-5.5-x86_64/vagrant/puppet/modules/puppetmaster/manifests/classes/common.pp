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
	
	# Create User
	user { '$appuser': 
		ensure	=> present,
		uid	=> '507',
		gid	=> '507',
		require => Group['$appgroup'],
	}

	# Create Group
	group { '$appgroup':
		ensure => present,
		gid => 507,
	}
	
	# Download repo files
	file { '/etc/yum.repos.d/prosvc.repo':
		ensure => present,
		source => 'http://yum.puppetlabs.com/prosvc/prosvc.repo',
		owner => 'root',
	}
	
	# RPMS
	package { 'puppetlabs-repo':
   		source => 'http://yum.puppetlabs.com/base/puppetlabs-repo-3.0-2.noarch.rpm',
		ensure => 'present';
	'puppet':
		ensure => '2.6.7-0.5.noarch';
	'puppet-server':
		ensure => '2.6.7-0.5.noarch';
	'puppet-dashboard':
		ensure => '1.1.0-1.noarch';
	'rpmforge-release':
		source => 'http://apt.sw.be/redhat/el5/en/i386/rpmforge/RPMS/rpmforge-release-0.3.6-1.el5.rf.i386.rpm',
		ensure => 'present';
	'epel-release':
		source => 'http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm',
		ensure => 'present';
	'ruby':
		ensure => '1.8.5-5.el5_4.8';
	'rubygems':
		ensure => '1.3.1-1.el5';
	'rubygem-rails':
		ensure => '2.1.1-2.el5';
	'rubygem-sqlite3-ruby':
		ensure => '1.2.4-1.el5';
	'ruby-devel':
		ensure => '1.8.5-5.el5_4.8';
	'ruby-mysql':
		ensure => '2.7.3-1.el5';
	'mysql-server':
		ensure => '5.0.77-4.el5_6.6';			
	}
	
	# Start and install mysql service
	service	{ 'mysqld':
		ensure => running,
		enable => true,
	}
	
	# rake DB migrate
	exec { 'db-migrate':
		enviroment => ['RAILS_ENV=production']
		command => 'cd /usr/share/puppet-dashboard && rake install && rake db:create && rake db:migrate'
	}
	
	# Change puppet config files
	file { '/etc/sysconfig/puppet':
		ensure => present,
		content => template('$project/puppet-sysconfig.erb');
	'/etc/sysconfig/puppetmaster':
		ensure => present,
		content => template('$project/puppetmaster-sysconfig.erb');
	'/etc/puppet/puppet.conf':
		ensure => present,
		content => template('$project/puppet-conf.erb');
	'/var/lib/puppet/lib/puppet/reports/puppet_dashboard.rb':
		ensure => present,
		content => template('$project/puppet_dashboard.rb.erb');
	}
	
}
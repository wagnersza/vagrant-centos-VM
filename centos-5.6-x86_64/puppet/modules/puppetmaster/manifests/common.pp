# Class: puppetmaster::common
#
# Puppet master common class
#
# Author: Wagner Souza (wagnersza@gmail.com)
#
class puppetmaster::common {

  include util::repo

	#Variables:
	$project = puppetmaster
	$appuser = puppet
	$appgroup = puppet
		
	# RPMS
	package {'puppet':
		# ensure => '2.6.7-0.5.noarch';
		ensure => 'latest';
	'puppet-server':
		# ensure => '2.6.7-0.5.noarch';
		ensure => 'latest';
  # 'puppet-dashboard':
  #   # ensure => '1.1.0-1.noarch';
  #   ensure => 'latest';   
	'ruby':
		# ensure => '1.8.5-5.el5_4.8';
		ensure => 'latest';
	'rubygems':
		# ensure => '1.3.1-1.el5';
		ensure => 'latest';
	'rubygem-rails':
		# ensure => '2.1.1-2.el5';
		ensure => 'latest';
	'rubygem-sqlite3-ruby':
		# ensure => '1.2.4-1.el5';
		ensure => 'latest';
	'ruby-devel':
		# ensure => '1.8.5-5.el5_4.8';
		ensure => 'latest';
	'ruby-mysql':
		# ensure => '2.7.3-1.el5';
		ensure => 'latest';
	'mysql-server':
		# ensure => '5.0.77-4.el5_6.6';			
		ensure => 'latest';
	}
	remote_rpm {'install_remote_rpm':
	  package => 'puppet-dashboard-1.2.2-1.el6.noarch.rpm',
	  host => 'http://downloads.puppetlabs.com/dashboard', 
	}
	
	# Start and install mysql service
	service	{ 'mysqld':
		ensure => running,
		enable => true,
	}
	
	# rake DB migrate
	exec { "db-migrate":
			require => [ Package["mysql-server"], Service["mysqld"] ],
			environment => ['RAILS_ENV=production'],
			command => "sh -c 'cd /usr/share/puppet-dashboard && rake install && rake db:create && rake db:migrate'";
	}

	# Create report dir	
	exec {"mkdir-reports":
	#		require => [ Package["puppet-dashboard"] ],
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
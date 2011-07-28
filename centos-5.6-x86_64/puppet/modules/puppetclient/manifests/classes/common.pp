# Class: puppetclient::common
#
# Puppet client common class
#
# Author: Wagner Souza (wagnersza@gmail.com)
#
class puppetclient::common {

	#Variables:
	$project = puppetclient
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
	package {'ruby':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		ensure => 'latest';
	'rubygems':
		require => [ File["prosvc.repo"], File["puppetlabs.repo"], File["rpmforge.repo"], File["epel.repo"] ],
		ensure => 'latest';	
	}
	
}
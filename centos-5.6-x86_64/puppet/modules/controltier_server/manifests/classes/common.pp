# Class: controltier_server::common
#
# controltier_server common class
#
# Author: Wagner Souza (wagnersza@gmail.com)
#
class controltier_server::common {

	#Variables:
	$project = controltier_server
	$appuser = controltier_server
	$appgroup = controltier_server
	
	# Repo files rpmforge
	file { 'rpmforge.repo':
		require => File["RPM-GPG-KEY-rpmforge-dag"],
		path => '/etc/yum.repos.d/rpmforge.repo',
		ensure => present,
		content => template("$project/repo/rpmforge.repo.erb"),
		owner => 'root';
	'RPM-GPG-KEY-rpmforge-dag':
		path => '/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
		ensure => present,
		content => template("$project/repo/RPM-GPG-KEY-rpmforge-dag.erb"),
		owner => 'root';
	}

	# Repo files epel
	file { 'epel.repo':
		require => File["RPM-GPG-KEY-EPEL"],
		path => '/etc/yum.repos.d/epel.repo',
		ensure => present,
		content => template("$project/repo/epel.repo.erb"),
		owner => 'root';
	'RPM-GPG-KEY-EPEL':
		path => '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL',
		ensure => present,
		content => template("$project/repo/RPM-GPG-KEY-EPEL.erb"),
		owner => 'root';
	}
	
	# Repo files ControlTier
	file { 'controltier36.repo':
		require => File["RPM-GPG-KEY-EPEL"],
		path => '/etc/yum.repos.d/controltier36.repo',
		ensure => present,
		content => template("$project/repo/controltier36.repo.erb"),
		owner => 'root';
	}
	
	# RPMS
	package {'ruby':
		require => [ File["rpmforge.repo"], File["epel.repo"] ],
		ensure => 'latest';
	'rubygems':
		require => [ File["rpmforge.repo"], File["epel.repo"] ],
		ensure => 'latest';
	'rubygem-rake':
		require => [ File["rpmforge.repo"], File["epel.repo"] ],
		ensure => 'latest';
	'ruby-devel':
		require => [ File["rpmforge.repo"], File["epel.repo"] ],
		ensure => 'latest';
	'ctier-server':
		require => [ File["controltier36.repo"] ],
		ensure => 'latest';
	}
	
	# Install Ruby Gems	
	exec { "install-gems":
			require => [ Package["ruby"], Package["rubygems"] ],
			command => "gem install fpm";
	}
	
}
# Class: nginx::common
#
# Nginx common class
#
# Author: Wagner Souza (wagnersza@gmail.com)
#
class nginx::common {

	#Variables:
	$project = nginx
	$appuser = nobody
	$appgroup = nobody
	
	# Repo files rpmforge
	file { 'rpmforge.repo':
		require => File["RPM-GPG-KEY-rpmforge-dag"],
		path => '/etc/yum.repos.d/rpmforge.repo',
		ensure => present,
		content => template("$project/repo/rpmforge.repo.erb"),
		owner => 'root',
	}

	file { 'RPM-GPG-KEY-rpmforge-dag':
		path => '/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag',
		ensure => present,
		content => template("$project/repo/RPM-GPG-KEY-rpmforge-dag.erb"),
		owner => 'root',
	}

	# Repo files epel
	file { 'epel.repo':
		require => File["RPM-GPG-KEY-EPEL"],
		path => '/etc/yum.repos.d/epel.repo',
		ensure => present,
		content => template("$project/repo/epel.repo.erb"),
		owner => 'root',
	}

	file { 'RPM-GPG-KEY-EPEL':
		path => '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL',
		ensure => present,
		content => template("$project/repo/RPM-GPG-KEY-EPEL.erb"),
		owner => 'root',
	}
	
	# RPMS
	package {'nginx':
		require => [ File["rpmforge.repo"], File["epel.repo"] ],
		ensure => 'latest';
	}
	
}
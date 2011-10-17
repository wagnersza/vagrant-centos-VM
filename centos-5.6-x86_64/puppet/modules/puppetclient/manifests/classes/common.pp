# Class: puppetclient::common
#
# Puppet client common class
#
# Author: Wagner Souza (wagnersza@gmail.com)
#
class puppetclient::common {

  include util::repo

	#Variables:
	$project = puppetclient
	$appuser = puppet
	$appgroup = puppet
	
	# RPMS
	package {'ruby':
		ensure => 'latest';
	'rubygems':
		ensure => 'latest';	
	}
	
}
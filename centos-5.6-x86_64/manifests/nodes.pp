node basenode {
	$puppet_master = "puppetmaster"
	$zone = "vagrant"
	$user_password = '$1$NrB1y8wm$APXJ5z4uE2.1uZ5C6NIB81'
	#include common
	#include puppet::common
}

node sandbox inherits basenode {
	$zone = "sandbox"
	$puppet_master = "puppet.local.com"
	#include user::puppet
	exec { "route add -net 10.2.0.0 netmask 255.255.0.0 gw 33.33.33.1 eth1":
	        unless => 'netstat -nrv | grep -e "10.2.0.0.*33.33.33.1"',
	}
}

node puppetmaster inherits sandbox {
        
		$puppetmaster_passwd = '$1$6FlrakZW$7P7npg/7rbgAt2r8hrJvC0'
		$puppetmaster_local_ipbind = '33.33.33.33'
		
		include role_puppetmaster
}

node puppetclient inherits sandbox {
        
		$puppetclient_passwd = '$1$6FlrakZW$7P7npg/7rbgAt2r8hrJvC0'
		$puppetclient_local_ipbind = '33.33.33.34'
		
		include role_puppetclient
}

node nginx inherits sandbox {
        
		$nginx_passwd = '$1$6FlrakZW$7P7npg/7rbgAt2r8hrJvC0'
		$nginx_local_ipbind = '33.33.33.35'
		
		include role_nginx
}

node rpmmaker inherits sandbox {
        
		$rpmmaker_passwd = '$1$6FlrakZW$7P7npg/7rbgAt2r8hrJvC0'
		$rpmmaker_local_ipbind = '33.33.33.36'
		
		include role_rpmmaker
}
node basenode {
	include common
}

node sandbox inherits basenode {
	$zone = "sandbox"
	$puppet_master = "puppet.local.com"
	$user_password = '$1$NrB1y8wm$APXJ5z4uE2.1uZ5C6NIB81'
	include user::puppet
	exec { "route add -net 10.2.0.0 netmask 255.255.0.0 gw 33.33.33.1 eth1":
	        unless => 'netstat -nrv | grep -e "10.2.0.0.*33.33.33.1"',
	}
}

node 'be.sandbox' inherits sandbox {
        
		$sandbox_appuser_passwd = '$1$6FlrakZW$7P7npg/7rbgAt2r8hrJvC0'
		$redis_sandbox_local_ipbind = '33.33.33.33'
		$nginx_be_sandbox_local_ipbind = '33.33.33.34'
		
		include role_sandbox-be
		
}

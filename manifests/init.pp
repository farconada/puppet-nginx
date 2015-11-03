class nginx (
  String $sites_enabled_source = ''
  )  {

  if $operatingsystem =~  /(?i-mx:centos|fedora|redhat)/ {
	$apache_servicename = 'httpd'
  }

  if $operatingsystem =~  /(?i-mx:ubuntu|debian)/  {
	$apache_servicename = 'apache2'
  }

  package {'nginx':
    ensure => latest
  }

  service {'nginx':
    ensure => running
  }

  service {$apache_servicename:
    ensure => stopped
  }

  if $sites_enabled_source != '' {
    notify {'nginx::config-dir':
      message => "nginx sites-enabled source: $sites_enabled_source"
    }
    file {'/etc/nginx/sites-enabled':
      ensure 	=> directory,
      source 	=> $sites_enabled_source,
      require 	=> Package['nginx']
    }
  }

  Package['nginx'] -> Service[$apache_servicename] ~> Service['nginx']
}

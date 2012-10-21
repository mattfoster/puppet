class current_cost {
  Package { 
    ensure => installed,
  }

  package { "ruby-collectd":
    name     => 'collectd',
    provider => gem,
  }

  package { 
    "ruby-daemons":; 
    "ruby-serialport":;
  }

  file { "/etc/init.d/current_cost":
    owner  => root,
    group  => root,
    mode   => 0755,
    source => "puppet:///modules/current_cost/current_cost.rb",
    notify => Service["current_cost"],
  }

  service { "current_cost":
    ensure  => running,
    enable  => true
  }

}

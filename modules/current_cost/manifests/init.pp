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

  file { "/usr/local/bin/current_cost.rb":
    owner  => root,
    group  => root,
    mode   => 0755,
    source => "puppet:///modules/current_cost/current_cost.rb",
  }

  service { "current_cost.rb":
    status => "/usr/local/bin/current_cost.rb",
    provider => "init",
  }

}

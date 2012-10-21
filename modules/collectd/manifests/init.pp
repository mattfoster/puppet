class collectd {
  package { "collectd":
    ensure => installed,
  }

  service { "collectd":
    ensure     => running,
    hasrestart => true,
    enable     => true,
  }

  File {
    owner => root,
    group => root,
    mode  => 0644,
  }

  file { "/etc/collectd/collectd.conf":
    content => template("collectd/collectd.conf.erb"),
    require => Package["collectd"],
    notify  => Service["collectd"],
  }
}

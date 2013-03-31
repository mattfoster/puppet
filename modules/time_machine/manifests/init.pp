class time_machine::install {
    Package {
        ensure => latest,
    }
    package {
	"netatalk":;
	"avahi":;
	"nss-mdns":;
    }

    service {
        "avahi-daemon":
            ensure => running;
    }
    service {
        "netatalk":
             ensure => running;
    }
}

class time_machine::config {
    File {
        owner => 'root',
        group => 'root',
    }
    file {
	"/etc/avahi/services/afpd.service":
	    source => "puppet:///modules/time_machine/afpd.service",
	    notify => Service["avahi-daemon"],
    }
    file {
	"/etc/netatalk/AppleVolumes.default":
	    source => "puppet:///modules/time_machine/AppleVolumes.default",
	    notify => Service["netatalk"],
    }
}

class time_machine {
    include time_machine::install, time_machine::config
}

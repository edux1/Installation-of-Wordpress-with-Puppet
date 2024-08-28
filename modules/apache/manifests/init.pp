class apache {
    exec { 'apt-update':
        command => '/usr/bin/apt-get update'
    }
    Exec["apt-update"] -> Package <| |>

    package { 'apache2':
        ensure => installed,
    }

    file { '/etc/apache2/sites-enabled/000-default.conf':
        ensure => absent,
        require => Package['apache2'],
    }

    service { 'apache2':
        ensure => running,
        enable => true,
        hasstatus  => true,
        restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",
    }

    notify { 'apache installed':
        message => "Module apache has been installed",
        require => File['/etc/apache2/sites-enabled/000-default.conf'],
    }
}


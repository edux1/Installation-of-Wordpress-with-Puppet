class mysql {   
    package { 'mysql-server':
        ensure => installed,
    }

    notify { 'mysql installed':
        message => "Module mysql-server has been installed",
        require => Package['mysql-server'],
    }
}
class wordpress {
    package { 'wordpress':
        ensure => installed,
    }

    file { '/etc/apache2/sites-available/wordpress.conf':
        ensure  => present,
        content => template('wordpress/wordpress.conf'),
        require => Package['wordpress'],
        notify  => Service['apache2'],
    }

    exec { 'a2ensite-wordpress':
        command     => 'sudo a2ensite wordpress',
        path        => '/usr/sbin:/usr/bin',
        refreshonly => true,
        subscribe   => File['/etc/apache2/sites-available/wordpress.conf'],
        user        => root,
        notify      => Service['apache2'],
    }

    file { '/etc/wordpress/config-localhost.php':
        ensure  => present,
        content => template('wordpress/config-localhost.php'),
        require => File['/etc/apache2/sites-available/wordpress.conf'],
    }

    exec { 'mysqlwordpress':
        command     => 'sudo cat /vagrant/wordpress.sql | sudo mysql --defaults-extra-file=/etc/mysql/debian.cnf',
        path        => '/usr/sbin:/usr/bin',
        refreshonly => true,
        subscribe   => File['/etc/wordpress/config-localhost.php'],
    }

    notify { 'wordpress installed':
        message => "Module wordpress has been installed",
        require => Exec['mysqlwordpress'],
    }
}
class wpcli {
    exec { 'download wp cli':
        command => 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar',
        path    => '/usr/local/bin:/usr/bin:/bin',
    }

    exec { 'chmod wp-cli':
        command => 'chmod +x wp-cli.phar',
        path    => '/usr/local/bin:/usr/bin:/bin',
        require => Exec['download wp cli'],
    }

    exec { 'mv wp-cli.phar':
        command => 'sudo mv wp-cli.phar /usr/local/bin/wp',
        path    => '/usr/local/bin:/usr/bin:/bin',
        require => Exec['chmod wp-cli'],
    }

    # Downloads some main files of wordpress in cwd
    exec { 'download wordpress':
        command => '/usr/local/bin/wp core download --allow-root',
        require => Exec['mv wp-cli.phar'],
    }

    file { '/vagrant/wp-content':
        ensure => directory,
        mode   => '0777',
        require => Exec['download wordpress'],
    }

    # Generates the file wp-config.php in cwd
    exec { 'configure wp config':
        command => '/usr/local/bin/wp core config --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost="localhost" --allow-root',
        require => File['/vagrant/wp-content'],
    }

    # Creates a database based on wp-config.php
    exec { 'wp db create':
        command => '/usr/local/bin/wp db create --allow-root',
        require => Exec['configure wp config'],
    }

    exec { 'wp core install':
        command => '/usr/local/bin/wp core install --url="localhost" --title="Actividad 1. Puppet" --admin_user="wordpress" --admin_password="wordpress" --admin_email="wordpress@admin.com" --allow-root',
        require => Exec['wp db create'],
    }

    #notify { 'wpcli installed':
    #    message => "Module wpcli has been installed",
    #    require => Exec['wp db create'],
    #}
}
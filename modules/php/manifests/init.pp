class php {
    # https://www.puppetcookbook.com/posts/install-multiple-packages.html

    # Global package parameter
    Package { ensure => 'installed' }

    # Specifing packages in an array
    $enhancers = ['php', 'libapache2-mod-php', 'php-cli', 'php-mysql']

    # Installing packages
    package { $enhancers: }

    notify { 'php installed':
        message => "Module php has been installed",
        require => [Service['apache2'], Package[$enhancers]],
    }
}
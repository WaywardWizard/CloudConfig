#!/usr/bin/python
import functools


class PhpFpmConfigurator:
    DEFAULT_SSL_PORT = 443
    DEFAULT_PORT = 80

    def __init__(
            self,
            host,  # hostname
            php,   # list of php versions
            ip=['*'],
            port=[DEFAULT_PORT, DEFAULT_SSL_PORT],  # listen ports
            sslPort=[DEFAULT_SSL_PORT]):  # Ports that should use ssl

        self.host = host
        self.php = php
        self.port = port
        self.sslPort = sslPort
        self.ip = ip

    def _generateBlock(self, ip, port, php):
        block = []
        for ipx in ip:
            block.append("<VirtualHost {}:{}>".format(ipx,port))
            block.append("\tServerName {}{}".format(self.host, php))
            block.append("\tDirectoryIndex /index.php index.php")
            if port in self.sslPort:
                block.append("\tRequestHeader set \"X-Forwarded-Proto\" expr=%{REQUEST_SCHEME}")
                block.append("\tRequestHeader set \"X-Forwarded-SSL\" expr=%{HTTPS}")
                block.append("\tSSLCertificateFile \"/etc/httpd/conf/server.crt\"")
                block.append("\tSSLCertificateKeyFile \"/etc/httpd/conf/server.key\"")

            block.append("\t<FilesMatch \.php|(tml)$>")
            block.append("\t\tSetHandler \"proxy:unix:/run/php{}-fpm/php-fpm.sock|fcgi://localhost\"".format(php))
            block.append("\t</FilesMatch>")
            block.append("</VirtualHost>")
        return block

    def generateConfig(self):
        block = []
        for ip in self.ip:
            for p in self.port:
                for php in self.php:
                    block.append(self._generateBlock(ip, p, php))
        result = ''
        for line in [xi for x in block for xi in x]:
            result += line + '\n'
        return(result)

    def generateHosts(self):
        hosts = ''
        for phpx in self.php:
            hosts += '127.0.0.1 localhost {}{}\n'.format(self.host, phpx)
        return(hosts)


cfg = PhpFpmConfigurator('crumpet', ['', '53', '56', '70', '71', '72'])
print(cfg.generateConfig())

print(cfg.generateHosts())

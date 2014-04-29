name             'docker-reg'
maintainer       'ASSA ABLOY AB'
maintainer_email 'claes.jonsson@assaabloy.com'
license          'All rights reserved'
description      'Installs/Configures a docker registry'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.8.0'

depends "apt"
depends "docker-registry"
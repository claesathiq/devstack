name             'gitlab'
maintainer       'ASSA ABLOY AB'
maintainer_email 'claes.jonsson@assaabloy.com'
license          'All rights reserved'
description      'Installs/Configures GitLab'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.8.0'

depends "apt"
depends "aws"
gitlab Cookbook
===============
This cookbook installs GitLab using the Omnibus installer, see <a href="https://www.gitlab.com/downloads/">https://www.gitlab.com/downloads/</a>

Requirements
------------
Currently only support Ubuntu

Default account
---------------
On first install, the default login is:
user: root
password: 5iveL!fe


Add separate data vaolume for git repos
---------------------------------------

Add an EBS volume, see this page
stackoverflow.com/questions/11535617/add-ebs-to-ubuntu-ec2-instance

Configure GitLab to use data area:




Make sure AWS instances get a FQDN
----------------------------------

When launching/starting instance: make sure to set user-data to <hostname>

In the script found on this page, set DOMAIN to you <yourdomain.com>

http://ternarylabs.com/2010/09/15/automatically-configure-hostname-for-new-ec2-instances/


Install Postfix
---------------

debconf-set-selections <<< "postfix postfix/mailname string your.hostname.com"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

apt-get install -y postfix mailutils libsasl2-2 ca-certificates libsasl2-modules


#file /etc/postfix/main.cf

# change:
relayhost = [smtp.gmail.com]:587
# add
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/postfix/cacert.pem
smtp_use_tls = yes


#file /etc/postfix/sasl_passwd

# add:
[smtp.gmail.com]:587  YOURUSERNAME@gmail.com:YOURPASSWORD

chmod 400 /etc/postfix/sasl_passwd

postmap /etc/postfix/sasl_passwd


# Check the certificates

cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem | sudo tee -a /etc/postfix/cacert.pem


/etc/init.d/postfix reload

# Send testmail

echo "Testing Postfix to relay mail through Gmail SMTP" | mail -s "Postfix Testing" yourname@example.com


Attributes
----------
#### gitlab::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['gitlab']['version']</tt></td>
    <td>String</td>
    <td>Version of GitLab to install</td>
    <td><tt>6.8.1</tt></td>
  </tr>
  <tr>
    <td><tt>['gitlab']['omnibus']['version']</tt></td>
    <td>String</td>
    <td>Version of Omnibus installer used to bundle this version of GitLb</td>
    <td><tt>6.8.1</tt></td>
  </tr>
  <tr>
    <td><tt>['gitlab']['installer']['md5']</tt></td>
    <td>String</td>
    <td>MD5 hash of installer, currently not used</td>
    <td><tt>93eb68aa407a33f01b376308bde0b465</tt></td>
  </tr>
</table>

Usage
-----
#### gitlab::default
Just include `gitlab` in your node's `run_list`:

```json
{
  "run_list": ["recipe[gitlab::default]"],
  "gitlab": {
      "host": "git",
      "domain": "localhost.com"
  }
}
```

License and Authors
-------------------
Authors: Claes Jonsson claes.jonsson@assaabloy.com

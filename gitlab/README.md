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

Make sure AWS instances get a FQDN
----------------------------------

See cookbook "ec2-hostname"


Add separate data volume for git repos
---------------------------------------

Attach new EBS volume to /dev/sdf to act as data volume

    mkfs.ext4 /dev/xvdf
    mkdir -m 000 /data
    echo "/dev/xvdf /data auto noatime 0 0" | tee -a /etc/fstab
    mount /data
    mkdir /data/git
    # creates /data/git

After installing gitlab

    chown git:git /data/git
    chmod 0700 /data/git

Configure GitLab to use data area:

in '/etc/gitlab/gitlab.rb' set

    git_data_dir "/data/git"


Add separate data volume for backup
---------------------------------------

Attach new EBS volume to /dev/sdg to act as data volume

    mkfs.ext4 /dev/xvdg
    
    mkdir -m 000 /backup
    echo "/dev/xvdg /backup auto noatime 0 0" | tee -a /etc/fstab
    mount /backup
    mkdir /backup/git
    # creates /backup/git

After installing gitlab

    chown git:git /backup/git
    chmod 0700 /backup/git


Configure GitLab to use backup area:

in '/etc/gitlab/gitlab.rb' set

    gitlab_rails['backup_path'] = "/backup/git"

See section on Backup for information about running and scheduling backups



Install Postfix
---------------

    debconf-set-selections <<< "postfix postfix/mailname string your.hostname.com"
    debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
    
    apt-get install -y postfix mailutils libsasl2-2 ca-certificates libsasl2-modules


file /etc/postfix/main.cf

change:

    relayhost = [smtp.gmail.com]:587
    
add

    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    smtp_sasl_security_options = noanonymous
    smtp_tls_CAfile = /etc/postfix/cacert.pem
    smtp_use_tls = yes


file /etc/postfix/sasl_passwd

add:

    [smtp.gmail.com]:587  YOURUSERNAME@gmail.com:YOURPASSWORD

run
    chmod 400 /etc/postfix/sasl_passwd
    postmap /etc/postfix/sasl_passwd


Check the certificates

    cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem | sudo tee -a /etc/postfix/cacert.pem

reload configuration

    /etc/init.d/postfix reload

Send testmail

    echo "Testing Postfix to relay mail through Gmail SMTP" | mail -s "Postfix Testing" yourname@example.com



LDAP sign-in
------------

These settings are documented in more detail at
https://gitlab.com/gitlab-org/gitlab-ce/blob/master/config/gitlab.yml.example#L118

Add to /etc/gitlab/gitlab.rb

    gitlab_rails['ldap_enabled'] = true
    gitlab_rails['ldap_host'] = 'hostname of LDAP server'
    gitlab_rails['ldap_port'] = 389
    gitlab_rails['ldap_uid'] = 'sAMAccountName'
    gitlab_rails['ldap_method'] = 'plain' # 'ssl' or 'plain'
    gitlab_rails['ldap_bind_dn'] = 'CN=query user,CN=Users,DC=mycorp,DC=com'
    gitlab_rails['ldap_password'] = 'query user password'
    gitlab_rails['ldap_allow_username_or_email_login'] = true
    gitlab_rails['ldap_base'] = 'DC=mycorp,DC=com'



Backup
------

###Backup settings
  backup:
    path: "<%= @backup_path %>"   # Relative paths are relative to Rails.root (default: tmp/backups/)
    keep_time: <%= @backup_keep_time %>   # default: 0 (forever) (in seconds)

    gitlab_rails['gitlab_backup_path'] = '/backup/git'

Run the following

    sudo gitlab-rake gitlab:backup:create


To schedule a cron job that backs up your repositories and GitLab metadata, use the root user:

    sudo su -
    crontab -e

There, add the following line to schedule the backup for everyday at 2 AM:

    0 2 * * * /opt/gitlab/bin/gitlab-rake gitlab:backup:create



Restore
-------

###Restoring an application backup
We will assume that you have installed GitLab from an omnibus package and run sudo gitlab-ctl reconfigure at least once.

First make sure your backup tar file is in /var/opt/gitlab/backups.

    sudo cp <timestamp>_gitlab_backup.tar /var/opt/gitlab/backups/

Next, restore the backup by running the restore command. You need to specify the timestamp of the backup you are restoring.

    # Stop processes that are connected to the database
    sudo gitlab-ctl stop unicorn
    sudo gitlab-ctl stop sidekiq
    
    # DROP THE CURRENT DATABASE; workaround for a Postgres backup restore bug in GitLab 6.6
    sudo -u gitlab-psql /opt/gitlab/embedded/bin/dropdb gitlabhq_production
    # This command will overwrite the contents of your GitLab database!
    sudo gitlab-rake gitlab:backup:restore BACKUP=1393513186
    
    # Start GitLab
    sudo gitlab-ctl start


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

    {
      "run_list": ["recipe[gitlab::default]"],
      "gitlab": {
          "host": "git",
          "domain": "localhost.com"
      }
    }

License and Authors
-------------------
Authors: Claes Jonsson claes.jonsson@assaabloy.com


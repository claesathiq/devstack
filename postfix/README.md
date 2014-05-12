postfix Cookbook
===============
This cookbook installs postfix


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



Usage
-----
#### postfix::default
Just include `postfix` in your node's `run_list`:


```json
{
	"run_list": ["recipe[postfix::default]"],
  	"bootstrap": {
    	"domain": "st.assaabloy.net"
  	}
}
```

License and Authors
-------------------
Authors: Claes Jonsson claes.jonsson@assaabloy.com

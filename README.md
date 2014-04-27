devstack
========

A shared dev stack for OpsWorks


The various layers are described below:

GitLab
======

The following JSON is used for the stack to configure the GitLab Layer

{
  "gitlab": {
    "host": "git.isassa.com",
    "url": "http://git.isassa.com/",
    "email_from": "gitlab@isassa.com",
    "support_email": "support@gisassa.com",
    "revision": "6-8-stable"
  },
  "postgresql": {
    "password": {
      "postgres": "psqlpass"
    }
  }
}
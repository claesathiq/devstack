devstack
========

A shared dev stack for OpsWorks



EC2 Machine Image
-----------------

All instances should be started on official Ubuntu Machine Images. This garantuees that they have cloud init installed.  
The image should also be EBS backed for persistent data, and para-virtualized for performance.

Suggested standard image is:

    ubuntu/images/ebs/ubuntu-precise-12.04-amd64-server-20140428 - ami-af7abed8

Go to `Community AMIs`and search for `ami-af7abed8`



Layers
------

The various layers are described below:

GitLab
======

The following JSON is used for the stack to configure the GitLab Layer

{
 "gitlab":
  {
   "host": "git",
    "domain": "isassaabloy.com"
  }
}
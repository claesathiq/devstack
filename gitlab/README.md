gitlab Cookbook
===============
This cookbook installs GitLab using the Omnibus installer, see <a href="https://www.gitlab.com/downloads/">https://www.gitlab.com/downloads/</a>

Requirements
------------
Currently only support Ubuntu

On first install, the default login is:
user: root
password: 5iveL!fe

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

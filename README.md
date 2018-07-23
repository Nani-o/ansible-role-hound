[![Build Status](https://travis-ci.org/Nani-o/ansible-role-hound.svg?branch=master)](https://travis-ci.org/Nani-o/ansible-role-hound)

hound
-----

This role installs [hound](https://github.com/etsy/hound), a source code search engine.

Compatibility
-------------

- Ubuntu 14.04
- Ubuntu 16.04
- Ubuntu 18.04

Variables
---------

###### hound_repo_url

Specify the hound repository url to use for installing it (If you want to use a fork for example).

By default this var is set to the original repo url.

```
hound_repo_url: https://github.com/etsy/hound.git
```

###### hound_go_url

You can specify directly the go format url that is used with the go command line tool (which is used to install hound). Though if you don't set it, this var is computed from the `hound_repo_url`.

```
hound_go_url: github.com/etsy/hound/cmds/...
```

###### hound_config_repos

The list of repos that will be put into the hound configuration.

```
hound_config_repos:
  ANameForTheRepo:
    url: https://github.com/Nani-o/ansible-role-hound.git
    ms-between-poll: 10000
    exclude-dot-files: true
```

License
-------

MIT

Author Information
------------------

Sofiane MEDJKOUNE

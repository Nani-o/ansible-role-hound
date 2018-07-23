[![Build Status](https://travis-ci.org/Nani-o/ansible-role-hound.svg?branch=master)](https://travis-ci.org/Nani-o/ansible-role-hound)

hound
-----

This role installs [hound](https://github.com/etsy/hound), a source code search engine.

Compatibility
-------------

- Ubuntu 14.04
- Ubuntu 16.04
- Ubuntu 18.04
- CentOS 7
- Debian 9
- Debian 8 (should work)

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

###### hound_config_github_user

If this var is specified, a script with a crontab will be setup in order to build a config file with all this Github user repositories.
You can still use hound_config_repos if you have other repositories that you want to setup with. They will be deployed in a seed.json file that will be merged with the Github user repositories.

```
hound_config_github_user: Nani-o
```

###### hound_config_github_user_excludes

A list of repositories you want to exclude from being auto discovered from the hound_config_github_user variable.

```
hound_config_github_user_excludes:
  - reponame
  - otherreponame
```

License
-------

MIT

Author Information
------------------

Sofiane MEDJKOUNE

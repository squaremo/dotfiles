These are tonyg's dotfile maintenance scripts.

The whole thing is much simpler than it seems :-)

## Quickstart

Put the "dotfiles" checkout in your home directory, ~/dotfiles.

Running "./setup.sh" without arguments will install symlinks and
config stanzas.

Running "./setup.sh -u" will uninstall symlinks and config stanzas.

When you're making changes, generally rerunning setup.sh will be incremental, but sometimes (e.g. if you move some file between directories) you will need to uninstall and reinstall the links to make sure they point in the right place.

Generally setup.sh is conservative, and won't overwrite files or
symlinks already present that point outside its tree.

## Details

./setup.sh is the main workhorse, and does all the work of installing
and uninstalling the configuration information held in (subdirectories
of) this directory. It is responsible for maintaining:

 - symbolic links in your home directory
 - symbolic links in your ~/bin directory
 - a stanza pulling config into your .emacs
 - a stanza pulling config into your .bashrc
 - a stanza pulling config into your .bash_profile, .bash_login, or .profile

It can install configuration files on a per-host, per-domainname, and
global basis. You can also keep common configuration separate from
more sensitive or private configuration: it supports multiple parallel
sources of configuration files, so you can use a common setup across
all your machines, and then have different overlays for work and for
home, with different git repos for each.

Here's how things are laid out:

.
|-- README.txt
|-- configs
|   |-- core
|   |   |-- bashrc.d
|   |   |   |-- *.sh
|   |   |   `-- anything else
|   |   |-- bin
|   |   |   `-- anything with +x
|   |   |-- domains
|   |   |   `-- any.SOME.DOMAIN
|   |   |       `-- (some domain-specific setup)
|   |   |-- emacs.d
|   |   |   `-- *.el
|   |   |-- home
|   |   |   `-- anything, incl hidden files/dirs
|   |   |-- hosts
|   |   |   |-- HOSTNAME1
|   |   |   |   `-- (some host-specific setup)
|   |   |   `-- HOSTNAME2
|   |   |       `-- (some host-specific setup)
|   |   `-- profile.d
|   |       `-- *.sh
|   `-- private
|       `-- (another overlay)
`-- setup.sh

The "configs" directory contains subdirectories, named anything you
like, that contain configuration overlays. By convention, there's
always one called "core", which is the basic stuff that should be on
every machine. You can also add arbitrary others, e.g. "home", "work",
containing stuff that perhaps shouldn't live in the main repo with the
core config.

Each such configuration overlay may contain subdirectories:

 - bashrc.d - any *.sh file within here will be executed whenever your
   .bashrc is run, in lexicographic order of file name.

 - bin - any executable file in here will be symlinked into ~/bin.

 - domains - contains further subdirectories, named as "any.*", where
   the * is to expand to a specific domain name. You can see, for a
   given machine, which of these will be used by running

      hostname -f | sed -e "s:$(hostname -s):any:"

 - emacs.d - any *.el file within here will be run whenever your
   .emacs is run, in lexicographic order of file name.

 - home - any file (starting with a dot or not, subdirectory or file)
   in here will be symlinked into your home directory.

 - hosts - contains further subdirectories, each named the same as the
   short name of a particular host. You can see, for a given machine,
   which of these will be used by running

      hostname -s

 - profile.d - any *.sh file within here will be executed whenever
   your .bash_profile, .bash_login or .profile (whichever of these is
   present in your home directory at the time setup.sh was run) is
   run, in lexicographic order of file name.

Each of the domain-specific and host-specific config directories can
in turn have bashrc.d, bin, emacs.d, home, and profile.d
subdirectories.

On occasion you will want some other git repository to be grafted in
to your config. Use git submodules for this. For example, I use a git
checkout of clojure-mode as a submodule. The setup.sh script will
automatically freshen the submodule list and do the grafting for you.

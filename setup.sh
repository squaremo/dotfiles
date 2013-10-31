#!/bin/sh
cd $(dirname "$0")
SETUPHOST="$(hostname -s)"
SETUPDOMAIN="$(hostname -f | sed -e "s:$(hostname -s):any:")"
echo "Setting up home directory from $(pwd) for host $SETUPHOST and domain $SETUPDOMAIN."

git submodule update --init

uninstall="no"
while getopts "u" opt; do
    case $opt in
	u)
            echo "Uninstalling links only."
	    uninstall="yes"
	    ;;
	*)
	    exit 1
	    ;;
    esac
done

set_shell_delimiters () {
    beginstr='# --- dotfiles BEGIN ---'
    endstr='# --- dotfiles END ---'
}
set_lisp_delimiters () {
    beginstr=';; --- dotfiles BEGIN ---'
    endstr=';; --- dotfiles END ---'
}
set_shell_delimiters

chopout () {
    cat $1 2>/dev/null \
	| awk "/^${beginstr}\$/{d = 1;} {if (!d) print} /^${endstr}\$/{d = 0}" > $1.tmp
    cat $1.tmp > $1
    rm $1.tmp
}

splicein () {
    echo "${beginstr}" >> $1
    cat >> $1
    echo "${endstr}" >> $1
}

invoke_d () {
    if [ "$uninstall" = "no" ]; then
	echo "Splicing in commands to $1"
	chopout $1
	splicein $1 <<EOF
for dotfiles_f in $(pwd)/configs/*/$2/*.sh ; do [ -f \$dotfiles_f ] && . \$dotfiles_f; done
for dotfiles_f in $(pwd)/configs/*/domains/$SETUPDOMAIN/$2/*.sh ; do [ -f \$dotfiles_f ] && . \$dotfiles_f; done
for dotfiles_f in $(pwd)/configs/*/hosts/$SETUPHOST/$2/*.sh ; do [ -f \$dotfiles_f ] && . \$dotfiles_f; done
unset dotfiles_f
EOF
    else
	echo "Removing commands from $1"
	chopout $1
    fi
}

link_dir () {
    echo "link_dir $1 $2"
    if [ ! -d $2 ]; then
	if [ "$uninstall" = "no" ]; then
	    echo "  - target dir not found, creating"
	    mkdir -p $2
	    if [ ! -d $2 ]; then
		echo "  - could not create target dir"
		return
	    fi
	else
	    return
	fi
    fi
    for f in $(find $2 -maxdepth 1 -type l)
    do
	t=$(dirname $(readlink $f))
	if [ "$t" = "$1" ]
	then
	    echo "  - found $f, removing ..."
	    rm $f
	fi
    done
    if [ "$uninstall" = "no" ]; then
	if [ ! -d $1 ]; then
	    echo "  - source dir not found, skipping"
	    return
	fi
	for f in $(find $1 -mindepth 1 -maxdepth 1)
	do
	    echo "  - recording $f ..."
	    ln -s $f $2
	done
    fi
}

###########################################################################

found=no
for profilefile in ~/.bash_profile ~/.bash_login ~/.profile
do
    printf "%-60s" "Checking for $profilefile"
    if [ -f "$profilefile" ]; then
	echo ... found
	found=yes
	break
    else
	echo ... not found
    fi
done
if [ "$found"="no" ]; then
    profilefile=~/.profile
    echo "Defaulting to $profilefile"
fi

invoke_d $profilefile profile.d
invoke_d ~/.bashrc bashrc.d

for configroot in configs/*
do
    link_dir $(pwd)/$configroot/home ~
    link_dir $(pwd)/$configroot/bin ~/bin
done

for configroot in configs/*
do
    link_dir $(pwd)/$configroot/hosts/$SETUPHOST/home ~
    link_dir $(pwd)/$configroot/hosts/$SETUPHOST/bin ~/bin
done

for configroot in configs/*
do
    link_dir $(pwd)/$configroot/domains/$SETUPDOMAIN/home ~
    link_dir $(pwd)/$configroot/domains/$SETUPDOMAIN/bin ~/bin
done

set_lisp_delimiters
if [ "$uninstall" = "no" ]; then
    echo "Splicing in commands to ~/.emacs"
    filesources=
    for configroot in configs/*
    do
	filesources="$filesources \"$(pwd)/$configroot/emacs.d\""
	filesources="$filesources \"$(pwd)/$configroot/domains/$SETUPDOMAIN/emacs.d\""
	filesources="$filesources \"$(pwd)/$configroot/hosts/$SETUPHOST/emacs.d\""
    done
    chopout ~/.emacs
    splicein ~/.emacs <<EOF
(require 'cl)
(let ((files (sort (mapcan '(lambda (d) (ignore-errors (directory-files d t ".*\.el$" t)))
			   '($filesources))
                   '(lambda (a b) (< (string-to-number (substitute ?  ?_
                                       (file-name-nondirectory a)))
                                     (string-to-number (substitute ?  ?_
                                       (file-name-nondirectory b))))))))
  (loop for file in files do (load file)))
EOF
else
    echo "Removing commands from ~/.emacs"
    chopout ~/.emacs
fi
set_shell_delimiters

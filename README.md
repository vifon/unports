Unports
=======

**Unports** is a humble attempt to provide an easy to use personal
package management system.  It is strongly inspired by the
FreeBSD Ports and aims to recreate their simplicity and general
structure.  It was also influenced by Portage used in Gentoo Linux.

**FEATURES**

- no root privileges required
- extremely simple package format

**DEPENDENCIES**

- git
- quilt
- wget

**EXAMPLES**

To see what *Unports* means by "extremely simple" consider these packages:

- a package for a release of [ncdu](https://dev.yorhel.nl/ncdu)

```Makefile
PKG = ncdu
VER = 1.13
URL = https://dev.yorhel.nl/download/$(ARCHIVE)

include ../unports.mk
```

- a package for GNU Emacs, the master branch from the Git repository

```Makefile
PKG = emacs
VER = git
URL = https://git.savannah.gnu.org/git/$P.git --depth 1

MAKEOPTS = -j5

include ../unports.mk
```

- another package for GNU Emacs, this time with a numbered version, also from Git

```Makefile
PKG = emacs
VER = git
URL = https://git.savannah.gnu.org/git/$P.git -b $(BRANCH) --depth 1

BRANCH = emacs-26.1
MAKEOPTS = -j5

include ../unports.mk
```

Installation
------------

To start using *Unports*, simply copy the `unports` directory into
`~/ports` and start filling it with your packages/ports (one directory
= one port).  Try copying there some of the examples first to see how
it works.

Syntax
------

Usually an unport consists of only a Makefile with these 4 lines:

```Makefile
PKG = some-name
VER = version
URL = https://example.com
include ../unports.mk
```

Variables:

- `PKG`: The name of the package, for example `emacs`.  It defaults to
  the current directory name.
- `VER`: The package version, usually a number like `1.9.2` but almost
  anything else is fine too.  The value `git` has a special meaning
  here, see below.
- `URL`: The meaning of `URL` depends on `VER`.  If `VER` is set to
  `git`, *Unports* expects `URL` to be a Git repository, otherwise
  `URL` is a simple URL to the archive.  `URL` can also contain
  additional Git flags in the former case, such as `--depth` or
  `--branch`.
  
Additionally the variable `P` is a shorthand for `PKG` and `PV` is the
same as `$(P)-$(VER)`, like in the Portage ebuilds.

Optional variables:

- `MAKEOPTS`: Can be used to pass some options to the `make` program
  used to build the package, for example `-j5` to utilize multiple
  CPUs.
- `NO_BUILD = 1`: Skip the `configure` and `build` steps.  Useful for
  example for the Python projects

Optional variables for Git-based packages:

- `BRANCH`: Can be used to select a Git branch, default: `master`.
- `REPO`: The name of the fetched bare repository, default: `$(P).git`.

Optional variables for archive-based packages:

- `ARCHIVE`: The name of the downloaded archive, defaults to: `$(PV).tar.gz`

Targets
-------

The installation process in *Unports* consists of these targets:

- `fetch`: Download the sources (dependency: either `git` or `wget`).
- `extract`: Unpack the sources (dependency: either `git` or `tar`).
- `patch`: Apply the patches if there are any (dependency:
  [quilt](https://savannah.nongnu.org/projects/quilt)).
- `configure`: Prepare the build process.
- `build`: Compile the package.
- `install`: Copy the program to its own directory (by default
  `~/pkgs/PROGRAM`).
- `merge`: Symlink the program to the common directory (by default
  `~/local`; dependency: [GNU Stow](https://www.gnu.org/software/stow/)).

Each of these targets may be invoked separately and each one will
first run all the previous ones if needed.  For example `make extract`
will download and unpack the sources.

**FETCH**

If `VER` is set to `git`, `fetch` clone the `URL` repository with the
`--bare` flag.

If `VER` isn't set to `git`, it download the file pointed with `URL`.
This file's name should be stored in `ARCHIVE` (defaults to
`$(PV).tar.gz`).

**EXTRACT**

If `VER` is set to `git`, clone locally the previously fetched bare
repository into a normal repository with a regular working tree.

If `VER` isn't set to `git`, use `tar` to unpack the previously
downloaded archive.

**PATCH**

Symlink the `patches` directory from the package directory to the
project source tree unpacked in the previous step.  Afterwards apply
all the patches in the Quilt series with `quilt push -a`.

If the `patches` directory doesn't exist, do nothing.

**CONFIGURE**

Run `./configure --prefix=$(PREFIX)` in the project source tree if
`configure` exists.  Calls `./autogen.sh` beforehand too if it exists.
If neither of these files exists, this step effectively does nothing.

Can be overriden with a script called `script/configure`.  The script
is started in the project source tree.

**BUILD**

Run `make $(MAKEOPTS)` in the project source tree.

Can be overriden with a script called `script/build`.  The script is
started in the project source tree.

**INSTALL**

Run `make PREFIX=$(PREFIX) install` in the project source tree to
install it into `$(PREFIX)`, by default `~/pkgs/$(PV)`.

Can be overriden with a script called `script/install`.  The script is
started in the project source tree.

**MERGE**

Run `stow -v -t ~/local -S $(PREFIX)` to merge the new package into
`~/local`.  `~/local` may be actually overriden with the `STOWDIR`
variable but it was not tested.

More targets
------------

There are also a few cleanup targets:

- `reset`: Forget which patch/configure/build steps were already
  performed so they will be remade.
- `clean`: Remove the project source tree.
- `distclean`: remove the whole working directory.

Each of these steps performs the previous one too.

- `unmerge`: Undo the `merge` step.
- `deinstall`: Undo the `merge` and `install` steps.

COPYRIGHT
=========

Copyright (c) 2018, Wojciech Siewierski

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
* Neither the name of ports nor the names of its contributors
  may be used to endorse or promote products derived from this software
  without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#!/bin/bash
# https://wiki.gnucash.org/wiki/Building_On_Linux

# -----------------------------------------------------------------------------------------------------
# Installing the Build Tools;
# -----------------------------------------------------------------------------------------------------
sudo apt install build-essential
sudo apt install autoconf      # loads autoscan, autoconf and associated macros
sudo apt install automake
sudo apt install libtool
sudo apt install m4
sudo apt install make
sudo apt install cmake


# -----------------------------------------------------------------------------------------------------
# Getting the GnuCash sources;
# -----------------------------------------------------------------------------------------------------
export VERSION=3.4                                                                        # One place to adjust the version;
export TARBALL=gnucash-$VERSION.tar.bz2                                                   # if you still have no bzip2 use ".gz" instead of ".bz2";
export URL=https://sourceforge.net/projects/gnucash/files/gnucash%20%28stable%29/$VERSION # ;
cd ~/Downloads                                                                            # "~" short for "$HOME" = "/home/<user>";
wget $URL/$TARBALL                                                                        # Download the tarball;
sha256sum $TARBALL                                                                        # Integrity check: Compare the output with the sha256sum from the URL;
mkdir ~/Applications -p
tar -xjvf $TARBALL -C ~/Applications                                                      # extract the tarball below your personal Applications directory;


# -----------------------------------------------------------------------------------------------------
# Installing Google Test;
# -----------------------------------------------------------------------------------------------------
#cd $HOME/.local/src
#git clone https://github.com/google/googletest.git
#cd googletest
#mkdir mybuild
#cd mybuild
#cmake -DBUILD_GMOCK=ON ../       # building gmock builds gtest by default
#make                             # build the static libraries
## the following commands will create environment variables which if set and installed shared or static libraries are not detected will allow CMake to locate the sources and compile them into the prject build.
## These environment variables can be made permanent by copying these commands into $HOME/.profile
#export GTEST_ROOT=$HOME/.local/src/googletest/googletest
#export GMOCK_ROOT=$HOME/.local/src/googletest/googlemock


# -----------------------------------------------------------------------------------------------------
# Installing Dependencies.
# -----------------------------------------------------------------------------------------------------
sudo apt install libtool libltdl-dev
sudo apt install libglib2.0 libglib2.0-dev   # glib2 > v2.40.0
sudo apt install icu-devtools libicu-dev
sudo apt install libboost-all-dev            # boost > 1.50.0  - requires locale and regex built with ICU support
sudo apt install guile-2.0 guile-2.0-dev     # guile >=2.0.0
#sudo apt install swig2.0                    # swig  >2.0.10  - swig3.0 on some systems
                                             # not required if building from tarball,
                                             # but required if building from a git clone
sudo apt install libxml2 libxml++2.6-dev libxml2-utils
sudo apt install libxslt1.1 libxslt1-dev
sudo apt install xsltproc
sudo apt install texinfo                     # required for makeinfo
sudo apt install libsecret-1-0

# Only use the next 2 lines if you have not installed [[Google_Test | Google Test]] already.
sudo apt install libgtest-dev                # >=1.7.0
sudo apt install google-mock                 # 1.8.0 installs googlemock in a subdirectory of gtest

sudo apt install gtk+3.0
sudo apt install libgtk-3-dev
sudo apt install libwebkit2gtk-4.0-37 libwebkit2gtk-4.0-dev  # > webkit2gtk-3.0

# Database Backend
sudo apt-get install libdbi1 libdbi-dev          # > v0.8.3
sudo apt-get install libdbd-pgsql                # PostgreSQL database
sudo apt-get install libdbd-mysql                # MySQL database
sudo apt-get install libdbd-sqlite3              # Sqlite database

# OFX File importing
sudo apt-get install libofx-dev   # This will automatically install the corresponding libofx<n> package as well.

# AqBanking
sudo apt-get install aqbanking-tools libaqbanking-dev   # > v4.0.0
sudo apt-get install gwenhywfar-tools libgwenhywfar60 libgwenhywfar60-dev


# -----------------------------------------------------------------------------------------------------
# Build and Install.
# -----------------------------------------------------------------------------------------------------
cd ~/Applications
mkdir build-gnucash-$VERSION              # create the build directory - Note: Named to identify the source since it is not within the source directory.
cd build-gnucash-$VERSION                 # change into the build directory
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_PREFIX_PATH=$HOME/.local ../gnucash-$VERSION     # As shown this will install in the .local directory in /home/<user>.  
make                                      # builds the program and associated libraries
make install                              # prefix with sudo if you do install to /usr/local or /opt as admin privileges are required.


# -----------------------------------------------------------------------------------------------------
# Finance:Quote
# -----------------------------------------------------------------------------------------------------
sudo perl $HOME/.local/bin/gnc-fq-update
sudo perl $HOME/.local/bin/gnc-fq-check
perldoc -lm Finance::Quote

# -----------------------------------------------------------------------------------------------------
# Uninstall
# https://wiki.gnucash.org/wiki/Uninstall_Gnucash_Linux.
# -----------------------------------------------------------------------------------------------------
#cd ~/Applications/build-gnucash-$VERSION            # either the original build directory or the rebuilt version as above.
#make uninstall                                      # prefix with sudo if installed in /usr/local or /opt or another location requiring admin privileges.

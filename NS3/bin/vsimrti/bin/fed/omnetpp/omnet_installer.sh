#!/usr/bin/env bash
#
# omnet_installer.sh - A utility script to install OMNeT++/INET for VSimRTI.
# Ensure this file is executable via chmod a+x omnet_installer.
#
# author: VSimRTI developer team <vsimrti@fokus.fraunhofer.de>
# last updated: 05/04/2015
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#inet configuration
disabled_inet_features=(TCP_lwIP TCP_NSC INET_examples IPv6 IPv6_examples xMIPv6 xMIPv6_examples MultiNet WiseRoute Flood RTP RTP_examples SCTP SCTP_examples DHCP DHCP_examples Ethernet Ethernet_examples PPP ExternalInterface  ExternalInterface_examples MPLS MPLS_examples OSPFv2 OSPFv2_examples BGPv4 BGPv4_examples PIM PIM_examples DYMO AODV AODV_examples GPSR RIP RIP_examples  mobility_examples physicalenvironment_examples Ieee802154 apskradio  wireless_examples VoIPStream VoIPStream_examples SimpleVoIP SimpleVoIP_examples HttpTools HttpTools_examples_direct HttpTools_examples_socket DiffServ DiffServ_examples InternetCloud InternetCloud_examples Ieee8021d Ieee8021d_examples TUN BMAC LMAC CSMA TCP_common TCP_INET)

#misc
required_programs=( unzip tar bison flex protoc gcc python )
required_libraries=( "libprotobuf-dev (or equal) 3.3.0" )
downloaded_files=""

log() {
   STRING_ARG=$1
   printf "${STRING_ARG//%/\\%%}\n" ${*:2}
   return $?
}

warn() {
   log "${bold}${red}\nWARNING: $1\n${restore}" ${*:2}
}

fail() {
   log "${bold}${red}\nERROR: $1\n${restore}" ${*:2}
   #clean_up # do not remove everything on failure to be able to investigate the issue
   exit 1
}

has() {
   return $( which $1 >/dev/null )
}

check_shell() {
   if [ -z "$BASH_VERSION" ]; then
      fail "This script requires the BASH shell"
      exit 1
   fi
}

print_usage() {
   log "${bold}${cyan}[$(basename "$0")] -- An OMNeT++/INET installation script for VSimRTI${restore}"
   log "\nUsage: $0 -s path/to/omnetpp-5.3-src-linux.tgz [arguments]"
   log "\nArguments:"
   log "\n -s, --simulator path/to/omnetpp-5.3-src-linux.tgz"
   log "\n     provide the archive containing the OMNeT++ source"
   log "\n     You can obtain it from ${cyan}https://www.omnetpp.org/omnetpp/summary/30-omnet-releases/2329-omnetpp-5-4-1-core${restore}"
   log "\n -f, --federate path/to/omnetpp-patch-18.1.zip"
   log "\n     provide the archive containing the OMNeT++-federate and patches for coupling OMNeT++ to VSimRTI."
   log "\n     If not given, the omnetpp-patch is downloaded by this installation script."
   log "\n -i, --inet_src path/to/inet-3.6.x-src.tgz"
   log "\n     provide the archive containing the inet source code"
   log "\n     You can obtain it from ${cyan}https://inet.omnetpp.org/Download.html${restore}"
   log "\n     If not given, the inet-source files are downloaded by this installation script."
   log "\n -p, --regen-protobuf"
   log "\n     Regenerate Protobuf c++ source, when using a different version of protobuf 3."
   log "\n -q, --quiet"
   log "\n     less output, no interaction required"
   log "\n -j, --parallel <number of threads>"
   log "\n     enables make to use the given number of compilation threads"
   log "\n -u, --uninstall"
   log "\n     uninstalls the OMNeT++ federate"
   log "\n -h, --help"
   log "\n     shows this usage screen"
   log "\n"
   log "\n"
   log "\nNote: If the installation fails with a protobuf error, please call "
   log "\n      this script with the parameter \"-p\"."
}

get_arguments() {
    if [ "$#" -ge "1" ]; then
      if [ "${1:-}" == "-h" ] || [ "${1:-}" == "--help" ]; then
         print_usage
         exit 0
      else
        # note: if this is set to > 0 the /etc/hosts part is not recognized ( may be a bug )
        while [[ $# -ge 1 ]]
        do
            key="$1"
            case $key in
                -q|--quiet)
                    arg_quiet=true
                    ;;
                -u|--uninstall)
                    arg_uninstall=true
                    ;;
                -it|--integration_testing)
                    arg_integration_testing=true
                    arg_quiet=true
                    ;;
                -p|--gen-protobuf)
                    arg_regen_protobuf=true
                    ;;
                -s|--simulator)
                    arg_omnet_tar="$2"
                    shift # past argument
                    ;;
                -f|--federate)
                    arg_federate_patch_file="$2"
                    shift # past argument
                    ;;
                -F|--force)
                    arg_force=true
                    ;;
                -i|--inet)
                    arg_inet_src_file="$2"
                    shift # past argument
                    ;;
                -j|--parallel)
                    arg_make_parallel="-j $2"
                    shift # past argument
                    ;;
            esac
	    shift
        done
      fi
    fi

    if [ "$arg_uninstall" = false ] && [ "$arg_omnet_tar" == "" ]; then
      fail "Please provide at least the path to the omnet installer tar \n./omnet_installer.sh -s /path/to/omnetpp-src.tgz\n\nHint: Use -h or --help to list the options."
      exit 1
    fi
}

umask 027

set -o nounset
set -o errtrace
set -o errexit
set -o pipefail

trap clean_up INT

cyan="\033[01;36m"
red="\033[01;31m"
bold="\033[1m"
restore="\033[0m"

omnet_federate_url="http://www.dcaiti.tu-berlin.de/research/simulation/download/get/omnetpp-patch-18.1.zip"
inet_src_url="https://github.com/inet-framework/inet/releases/download/v3.6.4/inet-3.6.4-src.tgz"

premake5_url="https://github.com/premake/premake-core/releases/download/v5.0.0-alpha12/premake-5.0.0-alpha12-linux.tar.gz"
premake5_tar="$(basename "$premake5_url")"
premake5_autoconf_url="https://github.com/Blizzard/premake-autoconf/archive/master.zip"
premake5_autoconf_zip="$(basename "$premake5_autoconf_url")"

#arguments
arg_integration_testing=false
arg_quiet=false
arg_uninstall=false
arg_regen_protobuf=false
arg_omnet_tar=""
arg_federate_patch_file=""
arg_inet_src_file=""
arg_make_parallel=""
arg_force=false

#paths and names
omnet_dir_name_default="omnetpp-x.x"
federate_path="bin/fed/omnetpp"
omnet_dir_name="${omnet_dir_name_default}"
omnet_federate_filename="$(basename "$omnet_federate_url")"
patch_filename="inet.patch"
inet_src_filename="$(basename "$inet_src_url")"
working_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

extract_omnet_dir_name() {
  if [ "$arg_omnet_tar" != "" ]; then
    arg_omnet_tar_filename="$(basename "${arg_omnet_tar}")"
    tmp_dir_name="${arg_omnet_tar_filename%-src*}"
    if [ "${arg_omnet_tar_filename}" == "${tmp_dir_name}" ]; then
      log "Warning: falling back to ${omnet_dir_name_default} as name for installation directory"
      omnet_dir_name="${omnet_dir_name_default}"
    else
      omnet_dir_name="${tmp_dir_name}"
    fi
  fi
}


get_arguments $*
extract_omnet_dir_name

# where the inet source tree reside
inet_src_dir="${working_directory}/inet_src"

# where the inet ned files reside after successful build inet
inet_target_dir="${working_directory}/inet"

# where the omnetpp source tree reside
omnetpp_src_dir="${working_directory}/${omnet_dir_name}"

# where the omnetpp-federate tree reside
omnetpp_federate_src_dir="${working_directory}/omnetpp_federate_src"

# where the omnetpp and omnetpp-federate ned files reside after successful build of omnetpp and omnetpp-federate
omnetpp_federate_target_dir="${working_directory}/omnetpp-federate"

# where the omnetpp and omnetpp-federate binary reside
omnetpp_federate_target_dir_bin="${omnetpp_federate_target_dir}/bin"

# where the omnetpp and omnetpp-federate libraries reside
omnetpp_federate_target_dir_lib="${omnetpp_federate_target_dir}/lib"

# mkdir -p "${inet_target_dir}" will be overwritten by extract inet
mkdir -p "${omnetpp_federate_target_dir}"
mkdir -p "${omnetpp_federate_target_dir_bin}"
mkdir -p "${omnetpp_federate_target_dir_lib}"

extract_premake() {
  echo "extract premake"
  if [ ! -d "${omnetpp_federate_src_dir}" ]; then
    fail "Directory ${omnetpp_federate_src_dir} doesn't exists. Abort!"
  fi
  oldpwd=`pwd`
  cd ${omnetpp_federate_src_dir}
  tar xvf ../$premake5_tar
  unzip ../$premake5_autoconf_zip
  cp premake-autoconf-master/api.lua .
  cp premake-autoconf-master/autoconf.lua .
  cp premake-autoconf-master/clang.lua .
  cp premake-autoconf-master/gcc.lua .
  cp premake-autoconf-master/msc.lua .
  rm -fr premake-autoconf-master
  cd "$oldpwd"
}

print_info() {
   log "${bold}${cyan}[$(basename "$0")] -- An OMNeT++/INET installation script for VSimRTI$restore}"
   log "\nVSimRTI developer team <vsimrti@fokus.fraunhofer.de>"
   if [ ! -f "$arg_federate_patch_file" ]; then
     log "\nThis shell script will install the OMNeT++ network simulator ($omnet_dir_name) with the INET framework (in $omnet_federate_filename from $omnet_federate_url)."
   else
     log "\nThis shell script will install the OMNeT++ network simulator ($omnet_dir_name) with the INET framework (in local $arg_federate_patch_file)."
   fi
   log "\nIf there is an error (like a missing package) during the installation, the output may give hints about what went wrong.\n"
   if [ "$arg_quiet" = false ]; then
      read -p "Press any key to continue..." -n1 -s
      log "\n"
   fi
}

# Workaround for integration testing
set_environment_variables()
{
    export PATH="$PATH:${omnetpp_federate_target_dir_bin}"
    export LD_LIBRARY_PATH="${omnetpp_federate_target_dir_lib}"
}

ask_dependencies()
{
   if $arg_integration_testing || $arg_quiet; then
      return
   fi

   while  [ true ]; do
      log "Are the following dependencies installed on the system? \n"
      log "${bold}Libraries:${restore}"
      for lib in "${required_libraries[@]}"; do
	log "${bold}${cyan} $lib ${restore}"
      done
      log "\n${bold}Programs:${restore}"
      for prog in "${required_programs[@]}"; do
        log "${bold}${cyan} $prog ${restore}"
      done
      printf "\n[y/n] "
      read answer
      case $answer in
         [Yy]* ) break;;
         [Nn]* )
            log "\n${red}Please install the required dependencies before proceeding with the installation process${restore}\n"
            exit;;
         * ) echo "Allowed choices are yes or no";;
      esac
   done;
}

check_required_programs()
{
   for package in $1; do
      if ! has $package; then
         fail ""$package" required, but it's not installed. Please install the package (sudo apt-get install for Ubuntu/Debian) and try again.";
      fi
   done
}

check_directory() {
   cd "$working_directory"
   federate_working_directory=`echo "$working_directory" | rev | cut -c -${#federate_path} | rev`
   if [ "$federate_working_directory" == "$federate_path" ]; then
      return
   else
      fail "This doesn't look like a VSimRTI directory. Please make sure this script is started from "$federate_path"."
   fi
}

#check_environment_variables() {
#   if [[ ! $PATH =~ .*$omnet_bin.* ]]; then
#      warn ""$omnet_bin" is not in the \$PATH environment variable.";
#   fi
#   if [[ ! $LD_LIBRARY_PATH =~ .*$omnet_lib.* ]]; then
#      warn ""$omnet_lib" is not in the \$LD_LIBRARY_PATH environment variable.";
#   fi
#}

download() {
   if [ ! -f "$(basename "$1")" ]; then
      if has wget; then
         wget -q "$1" || fail "The download URL seems to have changed. File not found: "$1"";
      elif has curl; then
         curl -s -O "$1" || fail "The download URL seems to have changed. File not found: "$1"";
      else
         fail "Can't download "$1".";
      fi
   else
      warn "File $(basename "$1") already exists. Skipping download."
   fi
}

extract_omnet()
{
   cd "$working_directory"
   arg1="$1" #omnet archive
   if [ -f "$1" ]; then
      if [ -d "${omnetpp_src_dir}" ]; then
         fail "${omnetpp_src_dir} exists, please uninstall the existing installation before proceeding (-u or --uninstall)"
         exit 1;
      fi
      tar -xf "$arg1"
   else
      fail "${1} not found! Abort!";
   fi
}

extract_inet()
{
   cd "$working_directory"
   if [ -f "$1" ]; then
      if [ -d "${inet_src_dir}" ]; then
         fail "${inet_src_dir} exists, please uninstall the existing installation before proceeding (-u or --uninstall)"
         exit 1;
      fi
      tar -xf "$1"
      cd inet
      patch -p1 < ${omnetpp_federate_src_dir}/patches/inet-3.6.4-floating_point_math.patch
      cd "$working_directory"
      mv inet ${inet_src_dir}
      mkdir -p "${inet_target_dir}" # same name
   else
      fail "${1} not found! Abort!";
   fi
}

clean_up()
{
   #Always remove temporary files
   if [ -d ${inet_src_dir} ]; then
      rm -rf ${inet_src_dir}
   fi
   if [ -d ${omnetpp_src_dir} ]; then
      rm -rf ${omnetpp_src_dir}
   fi
   if [ -d ${omnetpp_federate_src_dir} ]; then
      rm -rf ${omnetpp_federate_src_dir}
   fi
   #Remove the downloaded files if wanted
   if [ -z "$downloaded_files" ]; then
      return
   fi

   if [ "$arg_integration_testing" = false ]; then
      while  [ true ]; do
         log "Do you want to remove the following files and folders? ${bold}${red} $downloaded_files ${restore} \n[y/n] "
         if $arg_quiet; then
            answer=Y
         else
            read answer
         fi
         case $answer in
            [Yy]* ) break;;
            [Nn]* ) return;;
            * ) echo "Allowed choices are yes or no";;
         esac
      done;
   fi
   cd "$working_directory"
   rm -rf $downloaded_files

}

uninstall()
{
   cd "$working_directory"
   if [ -d ${inet_target_dir} ]; then
      rm -rf ${inet_target_dir}
   fi
   if [ -d ${omnetpp_federate_target_dir} ]; then
      rm -rf ${omnetpp_federate_target_dir}
   fi
   if [ -d ${omnet_dir_name} ]; then
         rm -rf ${omnet_dir_name}
      fi
   find . -maxdepth 1 -type d -name "omnetpp-*.*" -exec rm -rf {} \;
   #call normal cleanup to remove temporary and downloaded files
   clean_up
}

configure_omnet()
{
   cd "${omnetpp_src_dir}"
   export PATH=$(pwd -L)/bin:$PATH
   sed -i -e "s/PREFER_CLANG=yes/PREFER_CLANG=no/" configure.user
   ./configure WITH_OSG=no WITH_TKENV=no WITH_QTENV=no WITH_OSGEARTH=no WITH_PARSIM=no

   #prevent bison from being called in parallel
   MAKEFILE_PATCH='+++ src/common/Makefile
@@ -87 +87,2 @@ $L/$(LIBNAME)$(DLL_LIB_SUFFIX) : $(OBJS)
-expression.tab.hh expression.tab.cc : expression.y
+expression.tab.hh : expression.tab.cc
+expression.tab.cc : expression.y
@@ -95 +96,2 @@ lex.expressionyy.cc: expression.lex
-matchexpression.tab.hh matchexpression.tab.cc : matchexpression.y
+matchexpression.tab.hh : matchexpression.tab.cc
+matchexpression.tab.cc : matchexpression.y
+++ src/nedxml/Makefile
@@ -95 +95,2 @@ nedelements.cc nedelements.h nedvalidator.cc nedvalidator.h : dtdclassgen.pl $(O
-ned1.tab.hh ned1.tab.cc : ned1.y
+ned1.tab.hh : ned1.tab.cc
+ned1.tab.cc : ned1.y
@@ -103 +104,2 @@ lex.ned1yy.cc: ned1.lex
-ned2.tab.hh ned2.tab.cc : ned2.y
+ned2.tab.hh : ned2.tab.cc
+ned2.tab.cc : ned2.y
@@ -111 +113,2 @@ lex.ned2yy.cc: ned2.lex
-msg2.tab.hh msg2.tab.cc : msg2.y
+msg2.tab.hh : msg2.tab.cc
+msg2.tab.cc : msg2.y
+++ src/sim/Makefile
@@ -124 +124,2 @@ $L/$(LIBNAME)$(DLL_LIB_SUFFIX) : $(OBJS)
-expr.tab.hh expr.tab.cc : expr.y
+expr.tab.hh : expr.tab.cc
+expr.tab.cc : expr.y'

   #if [[ $arg_make_parallel != "" && $arg_make_parallel != "-j 1" ]]; then
      #echo "$MAKEFILE_PATCH" | patch -p0
   #fi
}

build_omnet()
{
  cd "${omnetpp_src_dir}"
  make $arg_make_parallel MODE=debug base
  mkdir -p "${omnetpp_federate_target_dir_bin}"
  cp -r bin ${omnetpp_federate_target_dir}
  cp -r lib ${omnetpp_federate_target_dir}
}

configure_inet()
{
   cd "${inet_src_dir}"
   #disable unneeded features
   for feat in "${disabled_inet_features[@]}"; do
      echo "y" | ./inet_featuretool disable "$feat" > /dev/null
   done
   make makefiles
}

build_inet()
{
   mkdir -p "${omnetpp_federate_target_dir_lib}"
   cd "${inet_src_dir}"
   make $arg_make_parallel MODE=debug
   if [ -f "out/gcc-debug/src/libINET_dbg.so" ]; then
      cp "out/gcc-debug/src/libINET_dbg.so" "${inet_target_dir}"
      cp "out/gcc-debug/src/libINET_dbg.so" "${omnetpp_federate_target_dir_lib}"
   else
      fail "Shared library \"libINET_dbg.so\" not found. Something went wrong while building INET."
   fi
   if [ -d "src" ]; then
      (cd "src"; tar -cf - `find . -name "*.ned" -print` | ( cd "${inet_target_dir}" && tar xBf - ))
   else
      fail "Directory \"src\" not found. Something went wrong while building INET."
   fi
   cd "${working_directory}"
}

build_omnet_federate()
{
  cd "${omnetpp_federate_src_dir}"

  mv src/omnetpp_federate/util/* .

  if [ "${arg_regen_protobuf}" == "true" ]; then
    if [ -f ClientServerChannelMessages.pb.h ]; then
      rm ClientServerChannelMessages.pb.h
    fi
    if [ -f ClientServerChannelMessages.pb.cc ]; then
      rm ClientServerChannelMessages.pb.cc
    fi
  fi

  sed -i -e "s|/usr/local|.|" premake5.lua
  sed -i -e "s|../../../libs/vsimrti-collections/src/main/resources/com/dcaiti/vsimrti/coupling|.|" premake5.lua
  sed -i -e "s|../../../libs/vsimrti-collections/src/main/cpp/com/dcaiti/vsimrti/coupling|.|" premake5.lua
  sed -i -e "s|\"/usr/include\"|\"${omnetpp_src_dir}/include\", \"${inet_src_dir}/src\"|" premake5.lua
  sed -i -e "s|\"/usr/lib\"|\"${omnetpp_federate_target_dir_lib}\"|" premake5.lua
  sed -i -e "s|'opp_msgc'|'${omnetpp_federate_target_dir_bin}/opp_msgc'|" premake5.lua
  sed -i -e "s|/share/ned||" premake5.lua

  if [ "${arg_regen_protobuf}" == "true" ]; then
    ./premake5 gmake --generate-opp-messages --generate-protobuf --install
  else
    ./premake5 gmake --install
  fi
  make config=debug clean
  make -j1 config=debug # make is running targets in parallel, but we have to build 'prebuild'-target, target,
                        # and 'postbuild'-target sequentially

  cp bin/Debug/omnetpp-federate ${omnetpp_federate_target_dir_bin}
  ln -s ${omnetpp_federate_target_dir_bin}/omnetpp-federate ${omnetpp_federate_target_dir}
  cp lib/libomnetpp-federate.so ${omnetpp_federate_target_dir_lib}
  cp -r omnetpp_federate "${omnetpp_federate_target_dir}"
  cd ${working_directory}
}

omnetpp_install_ok=false
federate_install_ok=false
inet_install_ok=false

check_install () {
  if [ -d ${omnetpp_federate_target_dir} ]; then
    if [ -d ${omnetpp_federate_target_dir}/omnetpp_federate ]; then
      if [ ! -f ${omnetpp_federate_target_dir}/omnetpp_federate/package.ned ]; then
        federate_install_ok=false
      fi
    else
      federate_install_ok=false
    fi
  else
    federate_install_ok=false
  fi

  if [ -d ${omnetpp_federate_target_dir_bin} ]; then
    if [ ! -f ${omnetpp_federate_target_dir_bin}/opp_msgc ]; then
      omnetpp_install_ok=false
    fi
    if [ ! -f ${omnetpp_federate_target_dir_bin}/omnetpp-federate ]; then
      federate_install_ok=false
    fi
  else
    omnetpp_install_ok=false
    federate_install_ok=false
  fi

  if [ -d ${omnetpp_federate_target_dir_lib} ]; then
    if [ ! -f ${omnetpp_federate_target_dir_lib}/liboppenvir_dbg.so ]; then
      omnetpp_install_ok=false
    fi
    if [ ! -f ${omnetpp_federate_target_dir_lib}/libomnetpp-federate.so ]; then
      federate_install_ok=false
    fi
    if [ ! -f ${omnetpp_federate_target_dir_lib}/libINET_dbg.so ]; then
      inet_install_ok=false
    fi
  else
    omnetpp_install_ok=false
    federate_install_ok=false
  fi

  if [ -d ${inet_target_dir} ]; then
    if [ ! -f ${inet_target_dir}/libINET_dbg.so ]; then
      inet_install_ok=false
    fi
    if [ -d ${inet_target_dir}/inet ]; then
      if [ ! -f ${inet_target_dir}/inet/package.ned ]; then
        inet_install_ok=false
      fi
    else
      inet_install_ok=false
    fi

  else
    inet_install_ok=false
  fi
}

print_success() {
   log "${bold}\nDone! OMNeT++ was successfully installed.${restore}"
}

######## Preparation ########
check_shell

if [ "$arg_uninstall" = true ]; then
   log "Uninstalling..."
   uninstall
   exit 0
fi

log "Preparing installation..."
#extract_omnet_dir_name

print_info

ask_dependencies

log "Setting required environment variables..."
set_environment_variables

if [ "${arg_force}" == "false" ]; then
  omnetpp_install_ok=true
  federate_install_ok=true
  inet_install_ok=true
  check_install

  # fixme: inet uses clang instead of gcc when configured standalone (without omnet)
  if [ "${inet_install_ok}" == "false" ]; then
    omnetpp_install_ok=false
  fi

  if [ "${omnetpp_install_ok}" == "true" -a "${inet_install_ok}" == "true" -a "${federate_install_ok}" == "true" ]; then
    echo ""
    echo ""
    echo "OMNeT++ federate already installed. Use -F or --force to overwrite existing installation."
    echo ""
    exit 0;
  fi
fi

check_required_programs "${required_programs[*]}"

check_directory

#check_environment_variables

######## Downloading / extracting ########

if [ ${federate_install_ok} == "false" -o ${inet_install_ok} == "false" ]; then # inet needs patch from federate source
  log "Downloading premake5 from $premake5_url..."
  download "$premake5_url"
  log "Downloading premake-autoconf from $premake5_autoconf_url..."
  download "$premake5_autoconf_url"

  if [ ! -f "$arg_federate_patch_file" ]; then
    log "Downloading "$omnet_federate_url"..."
    download "$omnet_federate_url"
    downloaded_files="$downloaded_files $omnet_federate_filename"

    log "Extracting ${omnet_federate_filename} ..."
    unzip --qq -o "$omnet_federate_filename"
    mv omnetpp-federate ${omnetpp_federate_src_dir}
  else
    log "Extracting "$arg_federate_patch_file"..."
    unzip --qq -o "$arg_federate_patch_file"
    mv omnetpp-federate ${omnetpp_federate_src_dir}
  fi
fi

if [ "${inet_install_ok}" == "false" ]; then
  if [ ! -f "$arg_inet_src_file" ]; then
    log "Downloading $inet_src_url ..."
    download "$inet_src_url"
    downloaded_files="$downloaded_files $inet_src_filename"

    log "Extracting $inet_src_filename ..."
    extract_inet $inet_src_filename
  else
    log "Extracting $arg_inet_src_file ..."
    extract_inet $arg_inet_src_file
  fi
fi

if [ ${omnetpp_install_ok} == "false" ]; then
  log "Extracting "$arg_omnet_tar"..."
  extract_omnet "$arg_omnet_tar"

  ######## Buliding OMNeT++ ########
  log "Configuring OMNeT++..."
  configure_omnet

  log "Building OMNeT++..."
  build_omnet
fi

if [ ${inet_install_ok} == "false" ]; then
  ######## Building INET ########
  log "Configuring INET"
  configure_inet

  log "Building INET framework..."
  build_inet
fi

if [ ${federate_install_ok} == "false" ]; then
  ######## Building federate ########
  extract_premake
  log "Building OMNeT++ federate..."
  build_omnet_federate

  #log "Removing unneeded files from INET"
  #deploy_inet
fi

print_success

####### Cleaning up downloading and temporary files #########
log "Cleaning up..."
clean_up
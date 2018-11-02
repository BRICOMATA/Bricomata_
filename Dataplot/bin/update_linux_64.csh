#!/bin/csh
#
#  Name:     build_linux_64.csh
#  Purpose:  This is a build script for Dataplot.
#
#            1. This uses the c shell.  There is also a
#               version using the Bourne shell.
#
#            2. This version is for 64-bit machines.  There
#               is a separate build script for 32-bit machines.
#
#            3. You can set the following options below:
#
#               a. SRCDIR   = defines the location of the source
#                             directorty.  The default is "./" which
#                             only needs to be changed if this build
#                             script is in a different directory than
#                             the source files.
#               b. DPNAME   = defines the name for the Dataplot executable
#                             (typically set to "dataplot", but you may
#                             want to add a platform identifier or a date,
#                             e.g., dataplot_linux_2017_09_30).
#               c. FCOMP    = defines the name of the Fortran
#                             compiler.  This will typically be
#                             set to "gfortran".
#               d. FFLAGS   = defines options for the Fortran
#                             compiler.  You should typically only
#                             need to change these if you are using
#                             a Fortran compiler other than gfortran.
#               e. IOPT     = define the optimization level.  I have
#                             occassionally run into weird bugs at
#                             O2 or higher, so I default to O1.
#               f. IPREC    = the compile options are set to use
#                             64-bit for both single and double
#                             precision.  This is because several
#                             of the special function routines
#                             are based on double precision being
#                             64-bit.  I would like to correct this
#                             in a future version so that double
#                             precision would in fact be 128 bit.
#                             For now, I recommend leaving this as is.
#
#                             On 64-bit machines, some sites may have
#                             separate directories for 32-bit and 64-bit
#                             versions of some libraries.  This is most
#                             likely to occur for a site that supports both
#                             32-bit and 64-bit machines.  For example,
#                             32-bit libraries may be installed to
#                             "/usr/lib" while 64-bit libraries may be
#                             installed to "/usr/lib64".  If this is the
#                             case on your system, you may need to edit
#                             some lines in the script below to link
#                             libraries from the desired location.
#
#               g. BOUNDS_CHECK = specify whether bounds checking will be
#                                 turned ON.  This is primarily used for
#                                 debugging by the developers, so
#                                 recommended setting is OFF.
#               h. LARGE_MODEL = Dataplot's default workspace is 10
#                                columns by 1,500,000 rows.  You can
#                                edit a few lines in DPCOPA.INC to
#                                increase the maximum number of rows.
#                                If you increase it too large (say
#                                above 1,700,000 rows), you need to
#                                add a compilation switch to gfortran.
#                                This is only recommended if you really
#                                need it as it may decrease run time
#                                performance a bit (i.e., you trade off
#                                greater memory address space for speed).
#                                Also, this doesn't really help unless your
#                                machine has sufficient memory (say
#                                16GB or more).  That being said, we
#                                have created versions with 10 to 20
#                                million for the maximum number of rows.
#               i. Dataplot can optionally take advantage of several
#                  external libraries (primarily different graphics
#                  libraries.  The following flags should be set to "on"
#                  or "off" depending on whether or not the library is
#                  available.  If you are not sure what libraries you have,
#                  then on a first pass you may want to turn them all "off"
#                  with the exception of the X11 libraries.
#
#                  The following flags can be set
#
#                    i. HAVE_X11 - X11 library, default = on
#                   ii. HAVE_GD  - GD library for various bit-map graphics
#                                  formats (PNG, GIF, JPEG, BMP, TIFF, TARGA).
#                                  GD has several additional dependencies.
#                                  Note that several popular programs, e.g.
#                                  PERL, use GD, so the likelihood is high
#                                  that GD is in fact installed on your
#                                  system.
#                       HAVE_TIFF - TIFF library, only applies if HAVE_GD
#                                   is set to "on".  Provided so that you can
#                                   turn TIFF off if the version of GD on
#                                   your local system was built without
#                                   TIFF support.
#                       HAVE_VPX - VPX library, only applies if HAVE_GD
#                                  is set to "on".  Provided so that you can
#                                  turn VPX off if the version of GD on
#                                  your local system was built without VPX
#                                  support.  VPX is used for the webpp
#                                  format.  I recommend setting this to "off"
#                                  unless you know VPX is supported on your
#                                  system.
#                  iii. HAVE_LIBPLOT - Support for Unix libplot library (the
#                                      plotutils package).  Note that this
#                                      is an older Unix library that may or
#                                      may not be installed on your local
#                                      system.  Since this is no longer
#                                      installed by default on many Linux
#                                      distributions, the default is "off".
#                   iv. HAVE_RL - READLINE library for command line editing
#                                 (requires the readline, history and either
#                                 ncurses or termcap libraries).  Dataplot
#                                 assumes the current 6.x version of the
#                                 library.  If version 5.x is installed on
#                                 your system, you may want to set this to
#                                 "off".
#                    v. HAVE_AQUA - Aqua library.  This should be set to
#                                   "on" for Mac OS X and "off" for all
#                                   other systems.
#                   vi. HAVE_CAIRO - Cairo library.  This is still being
#                                    developed, so this should be set to
#                                    "off".
#                  vii. HAVE_OPEN_GL - Open-GL library.  This is also still
#                                      under development, so set to "off".
#                 viii. HAVE_GKS - GKS library.  I am currently testing
#                                  this with the GLI/GKS implementation,
#                                  but most users should set this to "off".
#
set echo
#rm -f *.o
set IPREC = "64-64"
#
#  Set location for source files, the name for Dataplot executable and
#  the name of the compiler.
#
#set SRCDIR = /usr/local/src/dataplot
#set SRCDIR = /home/heckert/dataplot/src
#set SRCDIR = /home/heckert/src/dataplot
#set SRCDIR = /home/heckert/src/dataplot
set SRCDIR = ./
set DPNAME = ./dataplot
set FCOMP = "gfortran"
set BOUNDS_CHECK = off
#set BOUNDS_CHECK = on
set LARGE_MODEL = off
#set LARGE_MODEL = on
#
#  Set preferred optimization level
#
#set IOPT = "-O0"
set IOPT = "-O1"
#set IOPT = "-O2"
if ( $BOUNDS_CHECK == "on" ) then
   set IOPT = "IOPT -g -fbounds-check"
endif

#
#  Set various flags described above.
#
#  First group: these libraries are typically available,
#  so they should typically be set to ON.
#
set HAVE_X11 = on
#set HAVE_X11 = off
set HAVE_RL = on
#set HAVE_RL = off
# GD support, specify separately if LIBTIFF and LIBVPX libraries supported
set HAVE_GD = on
#set HAVE_GD = off
set HAVE_TIFF = on
#set HAVE_TIFF = off
#set HAVE_VPX = on
set HAVE_VPX=off
#
#  Second group: these libraries may or may not be available on a
#  given installation.  Unless you know these libraries are
#  installed on your system, I recommend setting them to OFF.
#
#  Flag for libplot support.  Libplot will be available on
#  many, but not all, Linux/Unix platforms.  Adds a few graphics
#  devices not otherwise available (specifically, netPBM PNM, Adobe
#  Illustrator, xfig, CGM), but these additional devices may not
#  of interest to most users.  If HAVE_LIBPLOT turned ON, then
#  X11 must also be turned ON.
#
#set HAVE_LIBPLOT = on
set HAVE_LIBPLOT = off
if ( $HAVE_LIBPLOT == "on" ) then
   set HAVE_X11 = on
endif
#
#  Third group: use of these libraries is still in development/testing
#  phase or the library is for a specific platform, so should be set to
#  OFF for most users.
#
set HAVE_AQUA = off
#set HAVE_AQUA = on
set HAVE_CAIRO = on
#set HAVE_CAIRO = off
set HAVE_OPEN_GL = off
#set HAVE_OPEN_GL = on
set HAVE_GKS = off
#set HAVE_GKS = on
#
#  LDFLAG defines locations for libraries on your system.  Some
#  platforms may not use "/usr/lib" or may have a separate directory
#  for 64-bit libraries.
#
#set LDFLAG = "-L/usr/lib64  -L/usr/lib  -L/usr/local/lib -L$HOME/lib"
#set LDFLAG = "-L$HOME/lib -L/usr/lib64 -L/usr/lib  -L/usr/local/lib"
set LDFLAG = "-L/usr/lib64 -L/usr/lib  -L/usr/local/lib"
#
set FFLAGS2 = "$IOPT -fdefault-real-8 -fdefault-double-8"
set CFLAGS = "-ansi -c -m64"
set CFLAGS2 = " "
#
if ( $LARGE_MODEL == "on" ) then
   set FFLAGS2 = "$FFLAGS2 -mcmodel=medium"
   set CFLAGS = "$CFLAGS -mcmodel=medium"
endif
#
set FFLAGS3 = "-DDD -DI32"
if ( $IPREC == "64-128" ) then
   set FFLAGS2 = "$IOPT -fdefault-real-8 -fdefault-integer-8"
   set FFLAGS3 = "-DDQ -DI32"
endif
set CFLAGS = "$CFLAGS -I./ -I$HOME/include -I/usr/include -I/usr/local/include"
set FFLAGS = "-c $FFLAGS2"
set FFLAGS4 = " "
set CFLAGS3 = " "
#
if ( $HAVE_GD == "on" ) then
   set LDFLAG = "$LDFLAG -lgd -lpng -ljpeg -lz -lfontconfig -lfreetype -lpthread"
   set FFLAGS4 = "$FFLAGS4  -DHAVE_GD"
   if ( $HAVE_TIFF == "on" ) then
      set CFLAGS3 = "$CFLAGS3 -DHAVE_LIBTIFF"
      set LDFLAG = "$LDFLAG -ltiff"
   endif
   if ( $HAVE_VPX == "on" ) then
      set CFLAGS3 = "$CFLAGS3 -DHAVE_LIBVPX"
      set LDFLAG = "$LDFLAG -lvpx"
   endif
endif
#
if ( $HAVE_CAIRO == "on" ) then
   set LDFLAG = "$LDFLAG -lcairo"
   set FFLAGS4 = "$FFLAGS4  -DHAVE_CAIRO"
   set CFLAGS = "$CFLAGS -I/usr/include/cairo"
endif
#
if ( $HAVE_OPEN_GL == "on" ) then
  set LDFLAG = "$LDFLAG -lGLU -lGL"
  set FFLAGS4 = "$FFLAGS4  -DHAVE_OPEN_GL"
endif
#
if ( $HAVE_GKS == "on" ) then
  set LDFLAG = "$LDFLAG -lgks"
  set FFLAGS4 = "$FFLAGS4  -DHAVE_OPEN_GKS"
endif
#
#  Note: The libplot library makes use of a number of the supplemental
#        X11 libraries, not just Xlib.
#
if ( $HAVE_LIBPLOT == "on" ) then
  set LDFLAG = "$LDFLAG -lplot -lXaw -lXmu -lXt -lSM -lICE -lXext"
  set FFLAGS4 = "$FFLAGS4  -DHAVE_LIBPLOT"
endif
#
#  Note: for X11, may need to select 64-bit or 32-bit version of
#        the libraries
#
if ( $HAVE_X11 == "on" ) then
      set LDFLAG = "$LDFLAG -L/usr/X11R6/lib -lX11"
      set FFLAGS4 = "$FFLAGS4  -DHAVE_X11"
endif
#
#  For readline, need either the ncurses or the termcap library.
#  Check first for ncurses.  If ncurses not found, check for
#  termcap.  If neither found, turn off readline flag.
#
if ( $HAVE_RL == "on" ) then
  set LDFLAG = "$LDFLAG -lreadline -lhistory"
  locate libncurses
  if ( "$?" == "0" ) then
     set LDFLAG = "$LDFLAG -lreadline -lhistory -lncurses"
     set FFLAGS4 = "$FFLAGS4  -DHAVE_READLINE"
  else
     locate libtermcap
     if ( "$?" == "0" ) then
        set LDFLAG = "$LDFLAG -lreadline -lhistory -ltermcap"
        set FFLAGS4 = "$FFLAGS4  -DHAVE_READLINE"
     else
        set HAVE_RL = "OFF"
     endif
  endif
endif
#
#  Begin compilation
#
#  Note: for gfortran compiler, need to use ".F" rather than
#        ".f" to ensure that the pre-processor is run.  The
#        "-cpp" flag is suppossed to manually run the pre-processor,
#        but I get a compilation error on my system if I try to use
#        "-cpp".  So I have renamed all the source files to use a
#        ".F" extension.  Note that only a few of the files actually
#        use pre-processor options.
#
#$FCOMP  $FFLAGS -DHAVE_ISNAN $SRCDIR/dp1_linux.F
#$FCOMP  $FFLAGS  $SRCDIR/dp2.F
#$FCOMP  $FFLAGS  $SRCDIR/dp3.F
#$FCOMP  $FFLAGS  $SRCDIR/dp4.F
#$FCOMP  $FFLAGS  $SRCDIR/dp5.F
#$FCOMP  $FFLAGS  $SRCDIR/dp6.F
#$FCOMP  $FFLAGS  $SRCDIR/dp7.F
#$FCOMP  $FFLAGS  $SRCDIR/dp8.F
#$FCOMP  $FFLAGS  $SRCDIR/dp9.F
#$FCOMP  $FFLAGS  $SRCDIR/dp10.F
#$FCOMP  $FFLAGS  $SRCDIR/dp11.F
#$FCOMP  $FFLAGS  $SRCDIR/dp12.F
#$FCOMP  $FFLAGS  $SRCDIR/dp13.F
#$FCOMP  $FFLAGS  $SRCDIR/dp14.F
#$FCOMP  $FFLAGS  $SRCDIR/dp15.F
#$FCOMP  $FFLAGS  $SRCDIR/dp16.F
#$FCOMP  $FFLAGS  $SRCDIR/dp17.F
#$FCOMP  $FFLAGS  $SRCDIR/dp18.F
#$FCOMP  $FFLAGS  $SRCDIR/dp19.F
#$FCOMP  $FFLAGS  $SRCDIR/dp20.F
#$FCOMP  $FFLAGS  $SRCDIR/dp21.F
#$FCOMP  $FFLAGS  $SRCDIR/dp22.F
#$FCOMP  $FFLAGS  $SRCDIR/dp23.F
#$FCOMP  $FFLAGS  $FFLAGS4 $SRCDIR/dp24.F
#$FCOMP  $FFLAGS  $SRCDIR/dp25.F
#$FCOMP  $FFLAGS  $SRCDIR/dp26.F
#$FCOMP  $FFLAGS  $SRCDIR/dp27.F
#$FCOMP  $FFLAGS  $SRCDIR/dp28.F
#$FCOMP  $FFLAGS  $SRCDIR/dp29.F
#$FCOMP  $FFLAGS  $SRCDIR/dp30.F
#$FCOMP  $FFLAGS  $SRCDIR/dp31.F
#$FCOMP  $FFLAGS  $SRCDIR/dp32.F
#$FCOMP  $FFLAGS  $SRCDIR/dp33.F
#$FCOMP  $FFLAGS  $SRCDIR/dp34.F
#$FCOMP  $FFLAGS  $SRCDIR/dp35.F
#$FCOMP  $FFLAGS  $SRCDIR/dp36.F
#$FCOMP  $FFLAGS  $SRCDIR/dp37.F
#$FCOMP  $FFLAGS  $FFLAGS4 $SRCDIR/dp38.F
#$FCOMP  $FFLAGS  $SRCDIR/dp39.F
#$FCOMP  $FFLAGS  $SRCDIR/dp40.F
#$FCOMP  $FFLAGS  $SRCDIR/dp41.F
#$FCOMP  $FFLAGS  $SRCDIR/dp42.F
#$FCOMP  $FFLAGS  $SRCDIR/dp43.F
#$FCOMP  $FFLAGS  $SRCDIR/dp44.F
#$FCOMP  $FFLAGS  $SRCDIR/dp45.F
#$FCOMP  $FFLAGS  $SRCDIR/dpdds2.F
#$FCOMP  $FFLAGS  $SRCDIR/dpdds3.F
#$FCOMP  $FFLAGS  $SRCDIR/dpdds.F
#$FCOMP  $FFLAGS  $SRCDIR/edinit.F
#$FCOMP  $FFLAGS  $SRCDIR/edmai2.F
#$FCOMP  $FFLAGS  $SRCDIR/edsear.F
#$FCOMP  $FFLAGS  $SRCDIR/edsub.F
#$FCOMP  $FFLAGS  $SRCDIR/edwrst.F
#$FCOMP  $FFLAGS  $SRCDIR/fit3b.F
#$FCOMP  $FFLAGS  $SRCDIR/odrpck.F
#$FCOMP  $FFLAGS  $SRCDIR/starpac.F
#$FCOMP  $FFLAGS  $SRCDIR/cluster.F
#$FCOMP  $FFLAGS  $SRCDIR/compgeom.F
#$FCOMP  $FFLAGS  $SRCDIR/optimi.F
#rm libdataplot.a
#ar r libdataplot.a  fit3b.o odrpck.o starpac.o cluster.o compgeom.o optimi.o
#rm fit3b.o odrpck.o starpac.o cluster.o compgeom.o optimi.o
##
## Compile the C routines
#if ( $HAVE_GD == "on" ) then
#  gcc $CFLAGS  $SRCDIR/gd_src.c
#endif
#if ( $HAVE_CAIRO == "on" ) then
#  gcc $CFLAGS  $SRCDIR/cairo_src.c
#endif
#if ( $HAVE_OPEN_GL == "on" ) then
#  gcc $CFLAGS  $SRCDIR/gl_src.c
#endif
#if ( $HAVE_RL == "on" ) then
#  gcc $CFLAGS  $SRCDIR/rldp.c
#endif
#if ( $HAVE_X11 == "on" ) then
#  gcc $CFLAGS  $SRCDIR/x11_src.c
#endif
#if ( $HAVE_LIBPLOT == "on" ) then
#  gcc $CFLAGS  $SRCDIR/libplot_src.c
#endif
#if ( $HAVE_GKS == "on" ) then
#  gcc $CFLAGS  $SRCDIR/gks_src.c
#endif
#if ( $HAVE_AQUA == "on" ) then
#  gcc $CFLAGS  $SRCDIR/aqua_src.c
#endif
#
#  Link step
$FCOMP -o $DPNAME  $FFLAGS2 $FFLAGS4 $SRCDIR/main.F *.o -L./ -ldataplot $LDFLAG

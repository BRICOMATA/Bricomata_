#!c:/Perl/bin/Perl.exe
# NIST/SEMATECH Engineering Statistics Handbook Course Material Browser

require 5;  #this scrip requires perl version 5 or greater
use File::Copy;

#*************CONFIGURATION VARIABLES*****************************
# URL for handbook's starting page without http://server/
$HANDBOOK_URL = '/index.html';
# working directory
$SCRATCH_DIRECTORY = '/tmp';  #if its UNIX use /tmp  else \tmp
# navigation bar image directory (real operating system directory)
$NAVGIFDIR = 'cbuild';  #don't use foward slash "/" at the end, this it the navigation image folder
# is operating system unix? this is to choose between TAR and ZIP file. 
# $UNIX = 1; # 1 = TRUE, 0 = FALSE
$UNIX = 0; # 1 = TRUE, 0 = FALSE
# operating system command to package many files into one
# $PACKAGER_EXE = 'tar -cvf '; # for Unix/Linux platforms
$PACKAGER_EXE = 'wzzip ';

#********************************************************************
# navigation bar copyright statement (appears in footer)
$NAVCOPYRIGHT = '&copy; Copyright Advanced Micro Devices, Inc., 1998';
# navigation bar file names 
$NAVGIFLOGO = 'c-logo.gif';
$NAVGIFNEXT = 'c-next.gif';
$NAVGIFBACK = 'c-back.gif';
$VERSION = '1.08.08.03.1120'; # version #.date of last modified ex ver 1,Aug,05,03,time
#with the use of the module File::Copy the path separator is sytem independent.. alway use "/"
$PATH_SEPARATOR = "/"; 
umask 000;

# determine script name
$SCRIPT_NAME = $ENV{'SCRIPT_NAME'} || ${0};
$DOCUMENT_ROOT = $ENV{'DOCUMENT_ROOT'} || '.';



# read information from client
&parseCookies;
&parseRequest;
&check_browser;

# debugging
$DEBUG = $ENV{"DEBUG"} || $REQUEST{"debug"} || 0;

# determine whether user has already started building a course
$myCourse = $COOKIES{'ESH-Course'};
unless (defined($myCourse))
    {
    # generate "unique" course identifier
    $myCourse = time;
    }

# determine action
if (! defined($REQUEST{'action'}))
    {
    # initial view or reload
    &showFrameset;
    }
elsif ($REQUEST{'action'} eq "add")
    {
    # add selected document to course
    &addDocument;
    &showCourse;
    }
elsif ($REQUEST{'action'} eq "delete")
    {
    # delete selected document from course
    &deleteDocument;
    &showCourse;
    }
elsif ($REQUEST{'action'} eq "list")
    {
    # list course
    &showCourse;
    }
elsif ($REQUEST{'action'} eq "clear")
    {
    # delete course
    &deleteCourse;
    # generate new "unique" course identifier
    $myCourse = time;
    &showCourse;
    }
elsif ($REQUEST{'action'} eq "help")
    {
    # display introductory help page
    &showHelp;
    }
elsif ($REQUEST{'action'} eq "controls")
    {
    # display control buttons
    &showControls;
    }
elsif ($REQUEST{'action'} eq "step2")
    {
    if ($REQUEST{'button'} eq "Next >>")
        {
        &showResults;
        }
    elsif ($REQUEST{'button'} eq "Add")
        {
        &addBlankDocuments;
        &showResults;
        }
    elsif ($REQUEST{'button'} eq "Sort")
        {
        &sortDocuments;
        &showResults;
        }
    elsif ($REQUEST{'button'} eq "Assemble")
        {
        &sortDocuments;
        &assembleCourse;
        }
    else
        {
        print $REQUEST{'button'};
        }
    }
elsif ($REQUEST{'action'} eq "debug")
    {
    # display debugging information
    &showDebugInfo;
    }

exit;


###############################################################################
# top-level subroutines                                                       #
###############################################################################


sub addDocument
    {
    # identify local file to update
    local $myCourseFileName = &getCourseFileName(${myCourse});

    # ensure we have the document title (in case JavaScript failed to get it)
    if (! defined($REQUEST{'selectedDocTitle'})
        || $REQUEST{'selectedDocTitle'} eq "undefined")
        {
        $REQUEST{'selectedDocTitle'} = &getDocTitle($REQUEST{'selectedDoc'});
        }

    # construct line to write to document
    local $line = join("\t", $REQUEST{'selectedDocTitle'}, $REQUEST{'selectedDoc'});

    # append line to file
    open(LIST, ">>$myCourseFileName");
        print LIST $line;
        print LIST "\n";
    close(LIST);
    }


sub assembleCourse
    {
    local $document;
    local $title;
    local $i = 10000;
    local $folder;
    local @contents;
    local ($source, $destination);
    local ($pageprefix, $coursetitle);
    local @files;
    local %seen;
    local %remap;
    local $time = time();
    &log("Received assemble request for course ${myCourse} ver= ${VERSION} time=${time}");

    $pageprefix = $REQUEST{'pageprefix'} || 'esh';
    $coursetitle = $REQUEST{'coursetitle'} || 'Engineering Statistics';

    $MULTIPART_BOUNDARY = "Mayhem's-Wild-Goose-Chase-$$" ;

    # send overall response header
    print "Content-type: multipart/mixed; boundary=${MULTIPART_BOUNDARY}\n" ;
		#print "Content-type: text/html\n" unless ($browser);
    print "Set-cookie: ESH-Course=${myCourse}; expires=" . &getCookieExpiration . "\n";
    print "\n";

    # send text portion response header
    print "--" . $MULTIPART_BOUNDARY . "\n" if ($browser); 
		#print "<!DOCTYPE html PUBLIC -//W3C//DTD HTML 3.2//EN>";
		print "Content-type: text/html\n";
    print "\n";
    print "<HTML>\n";
    print "<HEAD>\n";
    print "<TITLE>NIST / SEMATECH Engineering Statistics Course Builder</TITLE>\n";
    print "</HEAD>\n";
    print '<BODY BGCOLOR="#FFFFCC" TEXT="#000000" LINK="#0000FF" VLINK="#FF0000">' . "\n";
    print "<FONT COLOR=\"#D60021\">";
    print "<STRONG>NIST / SEMATECH Engineering Statistics Course Builder</STRONG>";
    print "</FONT><P>\n";

    # debugging
    if ($DEBUG)
        {
        print "<TABLE BORDER=1>\n";
        print "<CAPTION>Contents of REQUEST Hash</CAPTION>\n";
        foreach $item (sort(keys(%REQUEST)))
            {
            print "<TR><TD>$item</TD><TD>$REQUEST{$item}</TD></TR>\n";
            }
        print "</TABLE><P>\n";
        }

    # make scratch directory for user
    $folder = join($PATH_SEPARATOR, $SCRATCH_DIRECTORY, "ESH-${myCourse}");
    print "folder is ${folder}<BR>\n" if ($DEBUG);
    if (-e $folder)
        {
        print "folder already exists<BR>\n" if ($DEBUG);
        if (-d $folder)
            {
            print "folder is a directory<BR>\n" if ($DEBUG);
            opendir(F, $folder);
            @contents = grep(!/^\.\.?$/, readdir(F));
            closedir(F);
            foreach $file (@contents)
                {
                $file = join($PATH_SEPARATOR, $folder, $file);
                unlink($file);
                }
            }
        else
            {
            print "folder is not a directory<BR>\n" if ($DEBUG);
            print "removing it<BR>\n" if ($DEBUG);
            unlink($folder);
            print "making folder<BR>\n" if ($DEBUG);
            mkdir($folder, 0755);
            print "status: $!<BR>\n" if ($? && $DEBUG);
            }
        }
    else
        {
        print "making folder<BR>\n" if ($DEBUG);
        mkdir($folder, 0755);
        print "status: $!<BR>\n" if ($? && $DEBUG);
        }

    &log("Assembling course in ${folder}");

    # copy navigation images
    print "Copying navigation images:\n<UL>\n";
    &log("copying navigation images");
    foreach $image ($NAVGIFLOGO, $NAVGIFNEXT, $NAVGIFBACK)
        {
        $simage = join($PATH_SEPARATOR, $DOCUMENT_ROOT, $NAVGIFDIR, $image);
        $dimage = join($PATH_SEPARATOR, $folder, $image);
				&log("Nav images source: ${simage} destination ${dimage}");
        print "$image<BR>\n";
        push(@files, $image);
        copy($simage, $dimage);
        &log("invoking copy command: ${cmd} ln 263 copy command updated");
        &log("error: $!") if ($?);
        }
    print "</UL>\n\n";

    print "Copying source pages:\n<UL>\n";
    &log("copying source pages");
    $i = -1;
    for (;;)
        {
        $i++;
        $lastpage = undef;
        $firstpage = undef;
        $blankpage = undef;
        $imgcounter = "a";

        $document = $REQUEST{'SOURCE' . $i};
        last unless $document;
        $ithis = substr($i+10000,   $[ + 1, 4);
        $iprev = substr($i+10000-1, $[ + 1, 4);
        $inext = substr($i+10000+1, $[ + 1, 4);
        $newtitle = $REQUEST{"TITLE${i}"} || "Untitled";

        $firstpage = 1 if ($document eq "introduction");
        $lastpage  = 1 if ($document eq "conclusion");
        # !!! previous line prevents unsorted placeholders from surviving
        $blankpage = 1 if (substr($document, 0, 5) eq "blank");

        unless ($firstpage || $lastpage)
            {
            $cleandocnumber = &getCleanDocNumber($i);
            $newtitle = $cleandocnumber . ' ' . $newtitle if ($cleandocnumber);
            }
				$source = $DOCUMENT_ROOT . $document;		
        $destination = join($PATH_SEPARATOR, $folder, "${pageprefix}${ithis}.htm");
        push(@files, "${pageprefix}${ithis}.htm");
        $remap{$source} = $destination;

        $lastslash = rindex($document, "/");
        $sourcedoc = substr($document, $lastslash + 1, length($document) - $lastslash);
        $sourcepath = substr($document, $[, $lastslash + 1);

        # tell user what we're copying
        print "${pageprefix}${ithis}.htm";
        print " = ";
        print "$sourcedoc" unless $blankpage;
        print "placeholder" if $blankpage;
        #print " ($sourcepath)" if ($sourcepath);
        print "<BR>\n";
        &log("copying ${sourcedoc} to ${destination}");

        open(D, ">$destination");

        # put new header into destination;
        print D "<HTML>\n\n";
        print D "<!-- Built from NIST / SEMATECH Engineering Statistics Handbook -->\n\n";
        print D "<HEAD>\n";
        print D "<TITLE>$newtitle</TITLE>\n";
        print D "</HEAD>\n\n";
        print D '<BODY BGCOLOR="#FFFFCC" TEXT="#000000" LINK="#0000FF" VLINK="#FF0000">' . "\n\n";

        print D '<!-- navigation bar begin -->' . "\n";
        print D '<TABLE WIDTH=540 CELLSPACING=20 CELLPADDING=0>' . "\n";
        print D '<TR>' . "\n";
        print D '<TD ALIGN="LEFT" VALIGN="BOTTOM">';
        print D '<A HREF="' . $pageprefix . '0000' . '.htm"><IMG SRC="c-logo.gif" ALT="Logo" BORDER=0></A>';
        print D '</TD>' . "\n";
        print D '<TD ALIGN="CENTER" VALIGN="BOTTOM">';
        print D '<BIG><STRONG>' . $coursetitle . '</STRONG></BIG>'; # <TALL><DARK><HANDSOME>?
        print D '</TD>' . "\n";
        print D '<TD ALIGN="RIGHT" VALIGN="BOTTOM">';
        print D '<A HREF="' . $pageprefix . $iprev . '.htm"><IMG SRC="c-back.gif" ALT="Back" BORDER=0></A>'
            unless $firstpage;
        print D '<A HREF="' . $pageprefix . $inext . '.htm"><IMG SRC="c-next.gif" ALT="Next" BORDER=0></A>'
            unless $lastpage;
        print D '</TD>' . "\n";
        print D '</TR>' . "\n";
        print D '</TABLE>' . "\n";
        print D '<!-- navigation bar end -->' . "\n\n";

        print D "<TABLE WIDTH=540 CELLSPACING=20>\n";
        print D "<TR><TD><B><BIG>$newtitle</BIG></B></TD></TR>\n";
        print D "</TABLE>\n\n";

        print D "<TABLE WIDTH=540 CELLSPACING=20>\n";
        if (-e $source)
            {
            open(S, $source); 

            # first read through original document's head
            while(<S>)
                {
                last if ($_ =~ '</HEAD>');
                }
            # then read down to end of original document's navigational table row
            while(<S>)
                {
                last if ($_ =~ '</TR>');
                }
            # copy content from original document's body
            while(<S>)
                {
                chomp($line = $_);
                if (/<IMG/i)
                    {
                    ($imgsrc) = ($line =~ /SRC="(.*)"/i);
                    /$imgsrc/;
                    $stuffbefore = $`;
                    $stuffafter  = $'; #' 
										&log("**Debug Images ln380 **before the concat** imgsrc= ${imgsrc}");	
                    $imgsrc = $sourcepath . $imgsrc;  
                    unless ($seen{$imgsrc}++)
                        {
                        $newimgname = $pageprefix . $ithis . $imgcounter++ . '.gif';
                        print $newimgname;
                        print " = ";
                        $lastslash = rindex($imgsrc, "/");
                        $sourceimg = substr($imgsrc, $lastslash + 1, length($imgsrc) - $lastslash);
                        print $sourceimg;
                        print "<BR>\n";
                        $remap{$imgsrc} = $newimgname;
                        }
                    else
                        { 
                        #print $remap{$imgsrc};1
                        #print "<BR>\n";   
                        }
                    print D $stuffbefore;
                    print D $newimgname;
                    print D $stuffafter;
                    print D "\n";
                    push(@files, $newimgname);
										$sfile = ($DOCUMENT_ROOT . $imgsrc);
										$dfile = join($PATH_SEPARATOR, $folder, $newimgname);
		                copy($sfile, $dfile);
#*******************************DEBUG*************************		

				&log("**Debug Images ln417 sfile = ${sfile}");
				&log("**Debug Images ln4xx dfile = ${dfile}");
                    				&log("**Debug Images ln4xx document = ${document}");
                    			  &log("**Debug Images ln4xx sourcepath = ${sourcepath}");
                    				&log("**Debug Images ln4xx source = ${source}");		
                    #				&log("**Debug Images ln4xx imgsrc= ${imgsrc}");	
                    				&log("**Debug Images ln4xx folder = ${folder}");
                    #				&log("**Debug Images ln424 newimgname = ${newimgname}");
#*******************************DEBUG*************************
                    }
                else
                    {
                    last if ($line =~ '</TABLE>');
                    print D;
                    }
                }
            close(S);
            }
        elsif ($document eq "introduction")
            {
            print D "<TR>\n<TD>\n";
            print D "<B>Topics to be covered:</B><P>\n\n";
            $j = 1; # skip introduction
            while (1)
                {
                if ($REQUEST{"TITLE${j}"})
                    {
                    last if ($REQUEST{"SOURCE${j}"} eq "conclusion");
                    $jthis = substr($j+10000,   $[ + 1, 4);
                    $cleandocnumber = &getCleanDocNumber($j);
                    print D $cleandocnumber . ' ' if ($cleandocnumber);
                    print D '<A HREF="' . $pageprefix . $jthis . '.htm">';
                    print D $REQUEST{"TITLE${j}"};
                    print D '</A><BR>';
                    print D "\n"; 
                    }
                else
                    {
                    last;
                    }
                $j++;
                }
            print D "</TD>\n</TR>\n";
            }
        elsif ($document eq "conclusion")
            {
            print D "<TR>\n<TD>\n";
            print D "<B>Topics Covered:</B><P>\n\n";
            $j = 1; # skip introduction
            while (1)
                {
                if ($REQUEST{"TITLE${j}"})
                    {
                    last if ($REQUEST{"SOURCE${j}"} eq "conclusion");
                    $jthis = substr($j+10000,   $[ + 1, 4);
                    $cleandocnumber = &getCleanDocNumber($j);
                    print D $cleandocnumber . ' ' if ($cleandocnumber);
                    print D '<A HREF="' . $pageprefix . $jthis . '.htm">';
                    print D $REQUEST{"TITLE${j}"};
                    print D '</A><BR>';
                    print D "\n"; 
                    }
                else
                    {
                    last;
                    }
                $j++;
                }
            print D "\n<P><B>Any questions?</B>\n\n";
            print D "</TD>\n</TR>\n";
            }
        elsif ($blankpage)
            {
            print D "\n\n<!-- add your page content in this table row -->\n";
            print D "<!-- duplicate the row for each new margin note -->\n\n";
            print D "<TR>\n";
            print D "<TD VALIGN=\"TOP\" WIDTH=\"15%\">\n";
            print D "<I>your margin notes go here</I>\n";
            print D "</TD>\n";
            print D "<TD VALIGN=\"TOP\" WIDTH=\"85%\">\n";
            print D "your page content goes here\n";
            print D "</TD>\n";
            print D "</TR>\n";
            print D "\n<!-- end of your page content -->\n\n";
            }

        print D "</TABLE>\n\n";

        # add footer
        print D '<!-- navigation bar begin -->' . "\n";
        print D '<TABLE WIDTH=540 CELLSPACING=20 CELLPADDING=0>' . "\n";
        print D '<TR>' . "\n";
        print D '<TD ALIGN="LEFT" VALIGN="BOTTOM">';
        print D $NAVCOPYRIGHT;
        print D '</TD>' . "\n";
        print D '<TD ALIGN="CENTER" VALIGN="BOTTOM">&nbsp;</TD>' . "\n";
        print D '<TD ALIGN="RIGHT" VALIGN="BOTTOM">';
        print D '<A HREF="' . $pageprefix . $iprev . '.htm"><IMG SRC="c-back.gif" ALT="Back" BORDER=0></A>'
            unless $firstpage;
        print D '<A HREF="' . $pageprefix . $inext . '.htm"><IMG SRC="c-next.gif" ALT="Next" BORDER=0></A>'
            unless $lastpage;
        print D '</TD>' . "\n";
        print D '</TR>' . "\n";
        print D '</TABLE>' . "\n";
        print D '<!-- navigation bar end -->' . "\n\n";

        print D "</BODY>\n";
        print D "</HTML>\n";
        close(D);
        $| = 1;
        }
    print "</UL>\n\n";

    chdir($folder) || print "can't chdir to $folder<BR>\n"; # !!!

    $| = 1;
		#unbuffer STDOUT:  $| = 1;
    if ($UNIX)
        {
        $package = 'mycourse.tar';
        $packcmd = join(" ", $PACKAGER_EXE, $package, sort @files);
        }
    else
        {
        $, = "\n";
        open(LIST, ">ziplist.txt");
        print LIST sort @files;
        close(LIST);
        $, = "";
        $package = 'mycourse.zip';
        $packcmd = join(" ", $PACKAGER_EXE, $package, '@ziplist.txt');
        }
    unlink $package if -e $package;
		
#******************DEBUG**************************************
						&log("**Debug Images ln55x PATH SEPARATOR = ${PATH_SEPARATOR}");
						&log("**Debug Images ln57x DOCUMENTROOT= ${DOCUMENT_ROOT}");
						
#************************************************************					
						
    &log("packing command: ${packcmd}");
    print "packcmd is ${packcmd}<BR>\noutput from packcmd:<BR>\n<PRE>\n" if ($DEBUG);
    open(CMD, "$packcmd |");
    while(<CMD>) { $line = $_; print $line if ($DEBUG); &log($line); }
    close(CMD);
    print "</PRE>\n" if ($DEBUG);

    # pause if debugging
    sleep(10) if ($DEBUG);

    # done with text portion response header, #note the boundary only works on Mozilla, not msIE
    print "--" . $MULTIPART_BOUNDARY . "\n" if ($browser); 
		
		#link
		my $linkzip = join($PATH_SEPARATOR, $folder, $package);
		&log("Link: ${linkzip}") unless ($browser);
			
		# push out the file directly
    if (-e $package)
        {
				if ($browser) #if nescape or mozilla
					 {
                # last step
                print "Content-type: text/html\n";
        				print "\n";
                print "<HTML>\n";
                print "<HEAD>\n";
                print "<TITLE>NIST / SEMATECH Engineering Statistics Course Builder</TITLE>\n";
                print "</HEAD>\n";
                print '<BODY BGCOLOR="#FFFFCC" TEXT="#000000" LINK="#0000FF" VLINK="#FF0000">' . "\n";
                print "<TABLE WIDTH=540 CELLSPACING=20 CELLPADDING=0>\n<TR>\n<TD>";
                print "<FONT COLOR=\"#D60021\">";
                print "<STRONG>NIST / SEMATECH Engineering Statistics Course Builder</STRONG>";
                print "</FONT><P>\n";
                print "Unpack the course file into its own directory, ";
                print "and open the first HTML document, ";
                print "${pageprefix}0000.htm, ";
                print "to view the course.\n";
        				print "<a href=${linkzip}>Download again</a>";
                print "</TD>\n</TR>\n";
                print "</TABLE>\n";
                print "</BODY>\n";
                print "</HTML>\n";

								# send next boundary
        				print "--" . $MULTIPART_BOUNDARY . "\n";
        			
                # push package out to browser 512 bytes at a time
        				open(ZIP, $package);
        				binmode (ZIP) unless ($UNIX); # only on windows??
        				binmode STDOUT unless ($UNIX);
        				print "Content-type: application/x-tar\n"  if  ($UNIX);
        		    print "Content-type: application/x-zip-compressed\n";
                $bytes = (stat($package))[7];
                &log("package is ${package} and is ${bytes} bytes");
        				print "Content-Disposition: attachment; filename=${package}\n";
        				print "Content-Length: ${bytes}\n\n";
                for ($loop=0; $loop <= $bytes; $loop += 512)
                    {
                    read(ZIP, $data, 512);
                    print $data;
                    }
        				binmode ZIP, ":text";
                close ZIP;
        				binmode STDOUT, ":text";
                print "\n";
				   }
					 else #if msIE or similar
					 {
					      #print "Content-type: text/html\n";
        				print "\n";
                print "<HTML>\n";
                #print "<HEAD>\n";
                #print "<TITLE>NIST / SEMATECH Engineering Statistics Course Builder</TITLE>\n";
                #print "</HEAD>\n";
                #print '<BODY BGCOLOR="#FFFFCC" TEXT="#000000" LINK="#0000FF" VLINK="#FF0000">' . "\n";
                #print "<TABLE WIDTH=540 CELLSPACING=20 CELLPADDING=0>\n<TR>\n<TD>";
                #print "<FONT COLOR=\"#D60021\">";
                #print "<STRONG>NIST / SEMATECH Engineering Statistics Course Builder</STRONG>";
                #print "</FONT><P>\n";
                print "Download the file below and unpack the course file into its own directory, ";
                print "and open the first HTML document, ";
                print "${pageprefix}0000.htm, ";
                print "to view the course.\n";
								print "<a href=${linkzip}>Download here</a>" ;
                print "</TD>\n</TR>\n";
                print "</TABLE>\n";
                print "</BODY>\n";
                print "</HTML>\n";
					 }
        }
    else
        {
        print "Content-type: text/html\n\n";
        print "<HTML>\n";
        print "<HEAD>\n";
        print "<TITLE>Error Assembling Course</TITLE>\n";
        print "</HEAD>\n";
        print '<BODY BGCOLOR="#FFFFCC" TEXT="#000000" LINK="#0000FF" VLINK="#FF0000">' . "\n";
        if ($?)
            {
            print "<P>An error occurred while assembling your course:\n";
            print "<UL>$!</UL>\n";
            }
        else
            {
            print "<P>Unable to find ${package}\n";
            }
        print "</BODY>\n";
        print "</HTML>\n";
        }

    # send final boundary
    print "--" . $MULTIPART_BOUNDARY . "--" . "\n" if ($browser);

    }

sub deleteCourse
    {
    # identify local file to update
    local $myCourseFileName = &getCourseFileName(${myCourse});
    # remove local file
    unlink $myCourseFileName if (-e $myCourseFileName);
    }


sub deleteDocument
    {
    # identify local file to update
    local $myCourseFileName = &getCourseFileName(${myCourse});
    return unless (-e $myCourseFileName);

    local @documents;
    local $document;
    local $title;
    local $i = 10000;

    # read lines into documents array
    open(LIST, $myCourseFileName);
    while(<LIST>)
        {
        chomp($line = $_);
        next if ($line eq "");
        # have to slip numeric counter in to maintain order
        push(@documents, join("\t", $i++, $line));
        }
    close(LIST);

    # continue only if there are documents
    return if ($#documents == $[ - 1);

    # starting at bottom, remove element containing selected doc
    # !!! this isn't necessarily the right instance if the selected doc
    # !!! occurs more than once in the user's list
    foreach $item (reverse(sort(@documents)))
        {
        if ($item =~ $REQUEST{'selectedDoc'})
            {
            # !!!
            $item = "blorf";
            last;
            }
        }

    # remove local file
    unlink $myCourseFileName if (-e $myCourseFileName);

    # now write them back out to the file
    open(LIST, ">$myCourseFileName");
    foreach $item (sort(@documents))
        {
        next if ($item eq "blorf");
        ($i, $title, $document) = split("\t", $item);
        print LIST $title, "\t", $document, "\n";
        }
    close(LIST);
    }


sub showChapters
    {
    # send response header
    print "Content-type: text/html\n";
    print "\n";

    print <<"CONTENT";
<HTML>
<HEAD></HEAD>
<BODY BGCOLOR="#FFFFCC" TEXT="#000000" LINK="#0000FF" VLINK="#FF0000">

</BODY>
</HTML>
CONTENT
    }


sub showControls
    {
    # send response header
    print "Content-type: text/html\n";
    print "\n";

    print <<"CONTENT";
<HTML>
<HEAD>
<SCRIPT LANGUAGE="JavaScript">
<!--
var source
// setSelectedDoc updates information within forms for access by CGI script
function setSelectedDoc(whichForm)
    {
    var requestedDoc = source.document.location.pathname
    whichForm.selectedDoc.value = requestedDoc
    }
function newSourceWindow()
    {
    if (source == null)
        source = window.open('$HANDBOOK_URL',
            'display');
    else if (source.document == null)
        source = window.open('$HANDBOOK_URL',
            'display');
    }
// -->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFCC" TEXT="#000000" LINK="#0000FF" VLINK="#FF0000" onLoad="newSourceWindow()">
<TABLE CELLSPACING="0" CELLPADDING="0">
    <TR>
    <TD>
    <FORM ACTION="$SCRIPT_NAME#bottom" METHOD="POST" NAME="frmAdd" TARGET="selection">
        <INPUT TYPE="Submit" NAME="button" VALUE="Add Page" onClick="setSelectedDoc(self.document.frmAdd)">
        <INPUT TYPE="Hidden" NAME="action" VALUE="add">
        <INPUT TYPE="Hidden" NAME="selectedDoc" VALUE="">
        <INPUT TYPE="Hidden" NAME="selectedDocTitle" VALUE="">
    </FORM>
    </TD>
    </TR>
    <TD>
    <FORM ACTION="$SCRIPT_NAME#bottom" METHOD="POST" NAME="frmDelete" TARGET="selection">
        <INPUT TYPE="Submit" NAME="button" VALUE="Remove Page" onClick="setSelectedDoc(self.document.frmDelete)">
        <INPUT TYPE="Hidden" NAME="action" VALUE="delete">
        <INPUT TYPE="Hidden" NAME="selectedDoc" VALUE="">
        <INPUT TYPE="Hidden" NAME="selectedDocTitle" VALUE="">
    </FORM>
    </TD>
    </TR>
    <TR>
    <TD>
    <FORM ACTION="$SCRIPT_NAME" METHOD="POST" TARGET="selection">
        <INPUT TYPE="Submit" NAME="button" VALUE="Clear All">
        <INPUT TYPE="Hidden" NAME="action" VALUE="clear">
        <INPUT TYPE="Hidden" NAME="selectedDoc" VALUE="">
        <INPUT TYPE="Hidden" NAME="selectedDocTitle" VALUE="">
    </FORM>
    </TD>
    </TR>
    <TR>
    <TD>
    <FORM ACTION="$SCRIPT_NAME" METHOD="POST" TARGET="_top">
        <INPUT TYPE="Submit" NAME="button" VALUE="Next >>">
        <INPUT TYPE="Hidden" NAME="action" VALUE="step2">
    </FORM>
    </TD>
    </TR>
</TABLE>
</BODY>
</HTML>
CONTENT
    }


sub showCourse
    {
    # identify local file to update
    local $myCourseFileName = &getCourseFileName(${myCourse});
    local @documents;
    local $document;
    local $title;
    local $i = 10000;

    # if file exists, read lines into documents array
    if (-e $myCourseFileName)
        {
        open(LIST, $myCourseFileName);
        while(<LIST>)
            {
            chomp($line = $_);
            next if ($line eq "");
            # have to slip numeric counter in to maintain order
            push(@documents, join("\t", $i++, $line));
            }
        close(LIST);
        }

    # send response header
    print "Content-type: text/html\n";
    print "Set-cookie: ESH-Course=$myCourse; expires=" . &getCookieExpiration . "\n";
    print "\n";

    print "<HTML>\n";
    print "<HEAD>\n";
    # note the links must be displayed in the display frame
    print "<BASE TARGET=\"display\">\n";
    print "</HEAD>\n";
    print "<BODY BGCOLOR=\"#FFFFFF\">\n";

    if ($#documents == $[ - 1)
        {
        print "No pages selected.\n";
        }
    else
        {
        print "Your selection:<BR>\n";
        foreach $item (sort(@documents))
            {
            chomp($item);
            ($i, $title, $document) = split("\t", $item);

            print "<A HREF=\"$document\">$title</A>";
            print "<BR>\n";
            }
        }

    # the URL that got us here will contain a within-document name
    print "<P><A NAME=\"bottom\"></A>\n";

    print "</BODY>\n";
    print "</HTML>\n";
    }


sub showDebugInfo
    {
    # send response header
    print "Content-type: text/html\n";
    print "\n";

    print <<"CONTENT";
<HTML>
<HEAD></HEAD>
<BODY>
button = $REQUEST{'button'}<BR>
action = $REQUEST{'action'}<BR>
selectedDoc = $REQUEST{'selectedDoc'}<BR>
selectedDocTitle = $REQUEST{'selectedDocTitle'}<BR>
ESH-Course = ${myCourse}<BR>
</BODY>
</HTML>
CONTENT
    }


sub showFrameset
    {
    # send response header
    print "Content-type: text/html\n";
    print "Set-cookie: ESH-Course=$myCourse; expires=" . &getCookieExpiration . "\n";
    print "\n";

    print <<"CONTENT";
<HTML>
<HEAD>
<TITLE>Course Builder</TITLE>
</HEAD>
<FRAMESET ROWS="50%,*">
    <FRAME NAME="controls"
           SRC="$SCRIPT_NAME?action=controls"
           SCROLLING="no">
    <FRAME NAME="selection"
           SRC="$SCRIPT_NAME?action=list"
           SCROLLING="yes">
</FRAMESET>
</HTML>
CONTENT
    }


sub showHelp
    {
    # send response header
    print "Content-type: text/html\n";
    print "\n";

    print <<"CONTENT";
<HTML>
<HEAD></HEAD>
<BODY BGCOLOR="#FFFFCC" TEXT="#000000" LINK="#0000FF" VLINK="#FF0000">
<FONT COLOR="#D60021">
<STRONG>NIST / SEMATECH Engineering Statistics Course Builder</STRONG>
</FONT><P>
Browse the Table of Contents in the upper left hand corner.<P>
Use the &quot;Add&nbsp;Page&quot; button below to include
the page you are browsing to your course materials.<P>
Your course selection will appear in the lower left hand corner.<P>
When finished selecting pages, use the &quot;Next&nbsp;&gt;&gt;&quot; button.<P>
</BODY>
</HTML>
CONTENT
    }


sub showResults
    {
    # send response header
    print "Content-type: text/html\n";
    print "Set-cookie: ESH-Course=$myCourse; expires=" . &getCookieExpiration . "\n";
    print "\n";

    print "<HTML>\n";
    print "<HEAD>\n";
    print "<TITLE>NIST / SEMATECH Engineering Statistics Course Builder</TITLE>\n";
    print "</HEAD>\n";
    print '<BODY BGCOLOR="#FFFFCC" TEXT="#000000" LINK="#0000FF" VLINK="#FF0000">' . "\n";

    print "<TABLE WIDTH=540 CELLSPACING=20 CELLPADDING=0>\n";
    print "<TR><TD>";
        print "<FONT COLOR=\"#D60021\">";
    print "<STRONG>NIST / SEMATECH Engineering Statistics Course Builder</STRONG>";
    print "</FONT><P>\n";

    # identify local file to update
    local $myCourseFileName = &getCourseFileName(${myCourse});
    local @documents;
    local $document;
    local $title;
    local $i = 10000;
    local $j;
    local $pageprefix;

    $pageprefix = $REQUEST{'pageprefix'} || 'esh';

    # !!! this is a bit delicate --
    # !!! if you add a button you may need to register it here
    if ($REQUEST{'button'} eq "Sort" || $REQUEST{'button'} eq "Add")
        {
        }
    else
        {
        # if file exists, read lines into documents array
        $j = 10000;
        if (-e $myCourseFileName)
            {
            open(LIST, $myCourseFileName);
            while(<LIST>)
                {
                chomp($line = $_);
                next if ($line eq "");
                # have to slip numeric counter in to maintain order
                push(@documents, join("\t", $j++, $line));
                }
            close(LIST);
            }
        # copy file into form-like arrays
        $i = 1; # in case they didn't select anything
        foreach $item (sort(@documents))
            {
            chomp($item);
            next if ($item eq "");
            ($j, $title, $document) = split("\t", $item);
            ($eshnumber, $eshtitle) = split(" ", $title, 2);
            $eshtitle =~ s/^\s+|\s+$//g; # remove leading and trailing spaces
            #$i = &naturalvalue($i);
            $REQUEST{"SOURCE${i}"} = $document;
            $REQUEST{"TITLE${i}"} = $eshtitle;
            $i++;
            }
        $REQUEST{"SOURCE0"}    = 'introduction';
        $REQUEST{"TITLE0"}     = 'Course Introduction';
        $REQUEST{"SOURCE${i}"} = 'conclusion';
        $REQUEST{"TITLE${i}"}  = 'Course Conclusion';
        }

    print "<FORM ACTION=\"$SCRIPT_NAME\" METHOD=\"POST\">\n";
    print "<INPUT TYPE=\"Hidden\" NAME=\"action\" VALUE=\"step2\">\n";

    # prompt for course title
    $REQUEST{'coursetitle'} = $REQUEST{'coursetitle'} || 'Engineering Statistics';
    print "<TABLE>\n";
    print "<TR>";
    print "<TD><STRONG>Course Title:</STRONG></TD>\n";
    print "<TD><INPUT TYPE=\"Text\" NAME=\"coursetitle\" VALUE=\"" .
        $REQUEST{'coursetitle'} . "\" SIZE=\"50\"></TD>\n";
    print "</TR>\n";
    print "<TR><TD>&nbsp;</TD></TR>\n";

    print "<TR BGCOLOR=\"#CCCCCC\">\n";
    print "<TD><B>Page Number</B></TD>\n";
    print "<TD VALIGN=\"BOTTOM\"><B>Page Title</B></TD>\n";
    print "</TR>\n";

    for ($j = 0; $j >= 0; $j++)
        {
        last unless ($REQUEST{"SOURCE${j}"});
        print "<TR>\n";
        print "<INPUT TYPE=\"Hidden\" NAME=\"SOURCE${j}\" VALUE=\"" .
            $REQUEST{"SOURCE${j}"} . "\">\n";
        #print "<TD>${eshnumber}</TD>\n";
        print "<TD>";
        if ('introduction:conclusion' =~ $REQUEST{"SOURCE${j}"})
            {
            print "&nbsp;";
            }
        else
            {
            print "<INPUT TYPE=\"Text\" NAME=\"NUM${j}A\" VALUE=\"" .
                $REQUEST{"NUM${j}A"} . "\" SIZE=\"2\" MAXLENGTH=\"4\">.";
            print "<INPUT TYPE=\"Text\" NAME=\"NUM${j}B\" VALUE=\"" .
                $REQUEST{"NUM${j}B"} . "\" SIZE=\"2\" MAXLENGTH=\"4\">.";
            print "<INPUT TYPE=\"Text\" NAME=\"NUM${j}C\" VALUE=\"" .
                $REQUEST{"NUM${j}C"} . "\" SIZE=\"2\" MAXLENGTH=\"4\">.";
            print "<INPUT TYPE=\"Text\" NAME=\"NUM${j}D\" VALUE=\"" .
                $REQUEST{"NUM${j}D"} . "\" SIZE=\"2\" MAXLENGTH=\"4\">";
            }
        print "</TD>\n";
        print "<TD><INPUT TYPE=\"Text\" NAME=\"TITLE${j}\" VALUE=\"" . $REQUEST{"TITLE${j}"} . "\" SIZE=\"50\"></TD>\n";
        print "</TR>\n";
        }

    print "</TABLE>\n";

    print "<P>Prefix for HTML files: \n";
    print "<INPUT TYPE=\"Text\" NAME=\"pageprefix\" VALUE=\"${pageprefix}\" SIZE=\"3\" MAXLENGTH=\"3\">";
    print " (three character maximum)<P>\n";

    print "<INPUT TYPE=\"Submit\" NAME=\"button\" VALUE=\"Add\">&nbsp;";
    print "<INPUT TYPE=\"Text\" NAME=\"addlpages\" VALUE=\"1\" SIZE=\"2\" MAXLENGTH=\"2\">&nbsp;blank&nbsp;page(s)<P>";

    print "<INPUT TYPE=\"Submit\" NAME=\"button\" VALUE=\"Sort\">\n";
    print "<INPUT TYPE=\"Submit\" NAME=\"button\" VALUE=\"Assemble\">\n";

    print "</FORM>\n";

    print "</TD></TR>\n";
    print "</TABLE>\n";

    #print "<PRE>";
    #foreach $key (sort(keys(%REQUEST)))
    #    { print "$key\t=\t$REQUEST{$key}\n"; }
    #print "</PRE>";

    print "</BODY>\n";
    print "</HTML>\n";
    }




###############################################################################
# secondary-level subroutines                                                 #
###############################################################################


# getCourseFileName converts course ID (cookie) into physical data file name
sub getCourseFileName
    {
    local $identifier = $_[0];
    local $result;

    # ensure that the holding directory exists, make it if necessary
    mkdir($SCRATCH_DIRECTORY, 0775)
        unless (-e $SCRATCH_DIRECTORY && -d _);
    # !!! should verify that it worked and report failure

    # assemble filename
    $result = join($PATH_SEPARATOR, $SCRATCH_DIRECTORY, "ESH-${identifier}.dat");

    return $result;
    }


# getDocTitle reads between the TITLE tags to return page title
sub getDocTitle
    {
    local $document = $_[0];
    local $title;

    $realname = join($PATH_SEPARATOR, $DOCUMENT_ROOT, $document);
    if (-e $realname)
        {
        open(DOC, $realname);
        while(<DOC>)
            {
            #last if ( ($title) = /<TITLE>(.*)<\/TITLE>/i ); # assumes one-line tag
            last if ( ($title) = /<TITLE>(.*)/i );
            }
        close(DOC);
        }

    $title =~ s`</TITLE>``gi;
    $title =~ s/\t/ /g;
    $title =~ s/^\s+|\s+$//g;
    return $title;
    }


# getCookieExpiration returns HTTP header friendly future time
sub getCookieExpiration
    {
    local ($future, $dd, $mm, $yy, $m);
    # calculate 60 days into future
    $future = time + 60 * 24 * 60 * 60;
    ($dd, $m, $yy) = (gmtime($future))[3,4,5];
    $mm = (Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec)[$m];
    return join("-", $dd, $mm, $yy + 1900) . ' GMT';
    }


# padleft will add leading zeroes, returning four characters
sub padleft
    {
    return substr('0000' . substr($_[0],0,4), -4, 4);
    }


# naturalvalue is intended to undo padleft
sub naturalvalue
    {
    return $_[0] + 0;
    }


# getDocNumber returns sort-able aaaa.bbbb.cccc.dddd
sub getDocNumber
    {
    local ($i, $j, $result);
    $i = $_[0];
    $result = "";
    for ($j = "A"; $j le "D"; $j++)
        {
        $result .= "." if ($result ne "");
        $result .= &padleft($REQUEST{"NUM$i$j"});
        }
    return $result;
    }


# getCleanDocNumber returns view-able a.[b.[c.[d]]]
sub getCleanDocNumber
    {
    local ($i, $result);
    $i = $_[0];
    # !!! this is pretty sloppy if I say so myself
    # assemble four digits each with a following decimal
    $result = &naturalvalue($REQUEST{"NUM${i}A"}) . '.' .
        &naturalvalue($REQUEST{"NUM${i}B"}) . '.' .
        &naturalvalue($REQUEST{"NUM${i}C"}) . '.' .
        &naturalvalue($REQUEST{"NUM${i}D"}) . '.';
    # working from the right remove 0.'s
    if (substr($result, 6, 2) eq '0.')
        {
        $result = substr($result, 0, 6);
        if (substr($result, 4, 2) eq '0.')
            {
            $result = substr($result, 0, 4);
            if (substr($result, 2, 2) eq '0.')
                {
                $result = substr($result, 0, 2);
                if ($result eq '0.')
                    {
                    $result = "";
                    }
                }
            }
        }
    return $result;
    }


# sortDocuments changes the %REQUEST hash
sub sortDocuments
    {
    local ($i, $source, %titles, %sources, %numbers);

    # first add the aaaa.bbbb.cccc.dddd number to the REQUEST hash
    # note that un-numbered pages will be 0000.0000.0000.0000
    for ($i = 0; $i >= 0; $i++)
        {
        $source = $REQUEST{"SOURCE${i}"};
        last unless ($source);
        $REQUEST{"NUM${i}"} = &getDocNumber($i);
        if ($REQUEST{"NUM${i}"} eq '0000.0000.0000.0000')
            {
            if ($source eq 'introduction')
                {
                $REQUEST{"NUM${i}"} = '0000.0000.0000.0000';
                }
            elsif ($source eq 'conclusion')
                {
                $REQUEST{"NUM${i}"} = '9999.9999.9999.9999.9999';
                }
            else
                {
                # make this un-numbered document unique: 9999.9999.9999.9999.????
                $REQUEST{"NUM${i}"} = '9999.9999.9999.9999.' . &padleft($i);
                }
            }
        # copy information into sortable hashes
        $numbers{$REQUEST{"NUM${i}"}} = $i;
        $sources{$REQUEST{"NUM${i}"}} = $source;
        $titles{$REQUEST{"NUM${i}"}} = $REQUEST{"TITLE${i}"};
        }

    #print "Content-type: text/html\n\n";
    #print "<PRE>";
    #foreach $key (sort(keys(%REQUEST)))
    #    { print "$key\t=\t$REQUEST{$key}\n"; }
    #print "</PRE><P>";

    # sort the hashes back into the REQUEST "arrays"
    $i = 0;
    foreach $number (sort(keys(%numbers)))
        {
        $REQUEST{"SOURCE${i}"} = $sources{$number};
        $REQUEST{"TITLE${i}"} = $titles{$number};
        if ($REQUEST{"SOURCE${i}"} ne 'conclusion' &&
            substr($number, 0, 20) eq '9999.9999.9999.9999.')
            {
            $REQUEST{"NUM${i}A"} = '';
            $REQUEST{"NUM${i}B"} = '';
            $REQUEST{"NUM${i}C"} = '';
            $REQUEST{"NUM${i}D"} = '';
            }
        else
            {
            $REQUEST{"NUM${i}A"} = &naturalvalue(substr($number, 0 * 5, 4));
            $REQUEST{"NUM${i}B"} = &naturalvalue(substr($number, 1 * 5, 4));
            $REQUEST{"NUM${i}C"} = &naturalvalue(substr($number, 2 * 5, 4));
            $REQUEST{"NUM${i}D"} = &naturalvalue(substr($number, 3 * 5, 4));
            }
        $i++;
        }

    #print "<PRE>";
    #foreach $key (sort(keys(%REQUEST)))
    #    { print "$key\t=\t$REQUEST{$key}\n"; }
    #print "</PRE><P>";

    }


# addBlankDocuments adds blank placeholder pages
sub addBlankDocuments
    {
    local ($i, $j, $k);
    local ($blankpages, $first_insert_page);
    local ($conclusion_title);

    # determine number of existing pages
    $blankpages = 0;
    for ($i = 0; $i >= 0; $i++)
        {
        $source = $REQUEST{"SOURCE${i}"};
        last unless ($source);
        if ($source eq 'conclusion')
            {
            $conclusion_title = $REQUEST{"TITLE${i}"};
            $first_insert_page = $i;
            }
        else
            {
            $blankpages += 1 if ($source =~ 'blank');
            }
        }

    # fix empty addlpages form element
    $REQUEST{'addlpages'} = 1 unless ($REQUEST{'addlpages'});
    $REQUEST{'addlpages'} += 0;

    # do the insert
    for ($i = 1; $i <= $REQUEST{'addlpages'}; $i++)
        {
        print "$i<BR>\n";
        $j = $first_insert_page + $i - 1; # form element number (starts w/zero)
        $k = $blankpages + $i; # document/cosmetic number (starts w/one)
        print "j = $j, k = $k<BR>\n";
        $REQUEST{"SOURCE${j}"} = "blank${k}";
        $REQUEST{"TITLE${j}"} = "Placeholder Page ${k}";
        $REQUEST{"NUM${j}A"} = "";
        $REQUEST{"NUM${j}B"} = "";
        $REQUEST{"NUM${j}C"} = "";
        $REQUEST{"NUM${j}D"} = "";
        }

    # restore conclusion page using $j leftover from for loop
    $j++;
    $REQUEST{"SOURCE${j}"} = "conclusion";
    $REQUEST{"TITLE${j}"} = $conclusion_title;
    }


# write to log file
sub log
    {
    local $message;
    local $logfile;
    chomp($message = $_[0]);
    $logfile = join($PATH_SEPARATOR, $SCRATCH_DIRECTORY, 'course-builder.log');
    if (-e $logfile)
        { open(LOG, ">>$logfile"); }
    else
        { open(LOG, ">$logfile"); }
    print LOG "$message\n";
    close(LOG);
    return;
    }


###############################################################################
# generic CGI utilities                                                       #
###############################################################################

# generic CGI utility to store form data in %REQUEST
sub parseRequest
    {
    local ($request, @nvpairs, $name, $value);

    # put form data into $request
    if ($ENV{'REQUEST_METHOD'} eq "POST")
        { read(STDIN, $request, $ENV{'CONTENT_LENGTH'}); }
    else
        { $request = $ENV{'QUERY_STRING'}; }

    # convert $request into hash %REQUEST
    @nvpairs = split(/&/, $request);
    foreach (@nvpairs)
        {
        ($name, $value) = split(/=/, $_);
        $name =~ tr/+/ /;
        $value =~ tr/+/ /;
        $name =~ s/%([A-F0-9][A-F0-9])/pack("C", hex($1))/gie;
        $value =~ s/%([A-F0-9][A-F0-9])/pack("C", hex($1))/gie;
        $value =~ s/;/$$/g;
        $value =~ s/&(\S{1,6})$$/&$1;/g;
        $value =~ s/$$/ /g;
        $value =~ s/\|/ /g;
        $value =~ s/^!/ /g;
        next if ($value eq "");
        $REQUEST{$name} .= ", " if ($REQUEST{$name});
        $REQUEST{$name} .= $value;
        }
    } # end parse_request

# generic CGI utility to store cookies in %COOKIES
sub parseCookies
    {
    local @key_value_pairs = ();
    local $key_value;
    local $key;
    local $value;
    @key_value_pairs = split(/;\s/, $ENV{'HTTP_COOKIE'});
    foreach $key_value (@key_value_pairs)
        {
        ($key, $value) = split(/=/, $key_value);
        $key   =~ tr/+/ /;
        $value =~ tr/+/ /;
        $key   =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex ($1))/eg;
        $value =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex ($1))/eg;
        next if ($value eq "");
        if (defined($COOKIES{$key}))
            {
            $COOKIES{$key} = join ("\0", $COOKIES{$key}, $value);
            }
        else
            {
            $COOKIES{$key} = $value;
            }
        }
    } # end parse_cookies
		
sub check_browser
    {
    $browser = 0;  #MSIE / AOL
    if ($ENV{'HTTP_USER_AGENT'} =~ /Mozilla/i)
    	 {
       if ($ENV{'HTTP_USER_AGENT'} !~ /MSIE/i and $ENV{'HTTP_USER_AGENT'} !~ /opera/i)
       		{
					    $browser = 1; #Netscape
          }
       }
    }

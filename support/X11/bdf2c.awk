# bdf2c.awk
# 
# Convert a BDF font into C language sprite definitions
# suitable to work with the z88dk X11/Xlib library emulation
#
# $Id: bdf2c.awk,v 1.1 2007-12-21 08:39:01 stefano Exp $
#

BEGIN {

FS = "[ \t]*"

datamode = 0;
commentchars = 1;
width = 0;
height = 0;

print "char _font[] = { ";

}

{

if (match($1,/FONT/))
    {
    	print "// " $2;
    	next;
    }

if (match($1,/STARTCHAR/))
    {
    	print "// " $2;

    	if ($2 == "space")
    	  commentchars = 0;

    	if (commentchars != 0)
    	{
    	  print "/*"
    	}

    	next;
    }

if (datamode == 1)
   {
	if (match($1,/ENDCHAR/))
	    {
	    	datamode = 0;
	    	if (commentchars != 0)
	    	{
	    	  print "*/"
	    	}
	    	next;
	    }
	if (length($1) == 2)
		print "0x" $1 ","
	else
		print "0x" substr($1,1,2) ", 0x" substr($1,3,2) ","
   }

if (match($1,/DWIDTH/))
    {
    	width = $2;
    	next;
    }
    
if (match($1,/BBX/))
    { 
    	height = $3;
    	next;
    }

if (match($1,/BITMAP/))
    {
    	datamode = 1;
    	if (height == 0)
    		print width "," 1 "," 0 ","
    	else
    		print width "," height ","
    	
    	next;
    }

next;
}

END {

print 0 " };"

}
#
# Makefile for bogomips program
#

# uncomment one of the followng definitions for DEFS

# use this for the portable bogomips program
DEFS	= -DPORTABLE_BOGOMIPS

# use this for the original Linux bogomips program
#DEFS	= -DCLASSIC_BOGOMIPS

# use this for the QNX specific bogomips program
#DEFS	= -DQNX_BOGOMIPS

# uncomment this if your system does not define CLOCKS_PER_SEC
# should match units returned by clock() function
# the value below works for SunOS 4.1
#DEFS	= -DPORTABLE_BOGOMIPS -DCLOCKS_PER_SEC=1000000

# use these flags if using gcc
CC	= gcc
CFLAGS	= -Wall -O2 -fomit-frame-pointer -finline-functions -N -s

# use these flags if you are not using gcc; modify as needed
#CC	= cc
#CFLAGS	= -O

bogomips: bogomips.c
	$(CC) $(DEFS) $(CFLAGS) -o bogomips bogomips.c

clean:
	$(RM) bogomips

install: bogomips bogomips.1
	cp bogomips /usr/local/bin/bogomips
	cp bogomips.1 /usr/local/man/man1/bogomips.1

dist:
	cd .. ; \
	tar -czvf bogo-1.2.tar.gz \
	bogo-1.2/{bogomips.c,bogomips.1,README,INSTALLING,TODO,CHANGES,BUGS,Makefile}

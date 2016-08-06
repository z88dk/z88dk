# Make sure you include -DHAVE_SNPRINTF in CFLAGS if your system
# does have snprintf!

# If you need (long long int) support and you sprintf supports it,
# define -DSNPRINTF_LONGLONG_SUPPORT

CC      = gcc

CFLAGS  = -DPREFER_PORTABLE_SNPRINTF -O3 \
	  -Wall -Wpointer-arith -Wwrite-strings \
	  -Wcast-qual -Wcast-align -Waggregate-return \
	  -Wmissing-prototypes -Wmissing-declarations \
	  -Wshadow -Wstrict-prototypes

#	  -DNEED_ASPRINTF -DNEED_ASNPRINTF -DNEED_VASPRINTF -DNEED_VASNPRINTF
#	  -DNEED_SNPRINTF_ONLY

# Digital Unix: native compiler usually produces better code than gcc
#CC     = cc
#CFLAGS = -DPREFER_PORTABLE_SNPRINTF -O4 -std1 -arch host

# Recommend to leave COMPATIBILITY empty for normal use.
# Should be set for bug compatibility when running tests
# too keep them less chatty.
COMPATIBILITY =

#COMPATIBILITY = -DSOLARIS_BUG_COMPATIBLE
#COMPATIBILITY = -DHPUX_BUG_COMPATIBLE
#COMPATIBILITY = -DDIGITAL_UNIX_BUG_COMPATIBLE
#COMPATIBILITY = -DPERL_BUG_COMPATIBLE
#COMPATIBILITY = -DLINUX_COMPATIBLE

.c.o:
	rm -f $@
	$(CC) $(CFLAGS) $(COMPATIBILITY) -c $*.c

all:snprintf.o Makefile

test::snprintf.o test.c Makefile
	$(CC) $(CFLAGS) $(COMPATIBILITY) snprintf.o -o $@ test.c

clean:
	/usr/bin/rm -f *.o test core

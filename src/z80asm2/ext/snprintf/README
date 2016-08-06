
                                  snprintf.c
                   - a portable implementation of snprintf,
       including vsnprintf.c, asnprintf, vasnprintf, asprintf, vasprintf
                                       
   snprintf is a routine to convert numeric and string arguments to
   formatted strings. It is similar to sprintf(3) provided in a system's
   C library, yet it requires an additional argument - the buffer size -
   and it guarantees never to store anything beyond the given buffer,
   regardless of the format or arguments to be formatted. Some newer
   operating systems do provide snprintf in their C library, but many do
   not or do provide an inadequate (slow or idiosyncratic) version, which
   calls for a portable implementation of this routine.
   
Author

   Mark Martinec <mark.martinec@ijs.si>, April 1999, June 2000
   Copyright © 1999, Mark Martinec
   
Terms and conditions ...

   This program is free software; you can redistribute it and/or modify
   it under the terms of the Frontier Artistic License which comes with
   this Kit.
   
Features

     * careful adherence to specs regarding flags, field width and
       precision;
     * good performance for large string handling (large format, large
       argument or large paddings). Performance is similar to system's
       sprintf and in several cases significantly better (make sure you
       compile with optimizations turned on, tell the compiler the code
       is strict ANSI if necessary to give it more freedom for
       optimizations);
     * return value semantics per ISO/IEC 9899:1999 ("ISO C99");
     * written in standard ISO/ANSI C - requires an ANSI C compiler.
       
Supported conversion specifiers and data types

   This snprintf only supports the following conversion specifiers: s, c,
   d, o, u, x, X, p (and synonyms: i, D, U, O - see below) with flags:
   '-', '+', ' ', '0' and '#'. An asterisk is supported for field width
   as well as precision.
   
   Length modifiers 'h' (short int), 'l' (long int), and 'll' (long long
   int) are supported.
   
   NOTE:
   
     If macro SNPRINTF_LONGLONG_SUPPORT is not defined (default) the
     length modifier 'll' is recognized but treated the same as 'l',
     which may cause argument value truncation! Defining
     SNPRINTF_LONGLONG_SUPPORT requires that your system's sprintf also
     handles length modifier 'll'. long long int is a language extension
     which may not be portable.
     
   Conversion of numeric data (conversion specifiers d, o, u, x, X, p)
   with length modifiers (none or h, l, ll) is left to the system routine
   sprintf, but all handling of flags, field width and precision as well
   as c and s conversions is done very carefully by this portable
   routine. If a string precision (truncation) is specified (e.g. %.8s)
   it is guaranteed the string beyond the specified precision will not be
   referenced.
   
   Length modifiers h, l and ll are ignored for c and s conversions (data
   types wint_t and wchar_t are not supported).
   
   The following common synonyms for conversion characters are supported:
     * i is a synonym for d
     * D is a synonym for ld, explicit length modifiers are ignored
     * U is a synonym for lu, explicit length modifiers are ignored
     * O is a synonym for lo, explicit length modifiers are ignored
       
   The D, O and U conversion characters are nonstandard, they are
   supported for backward compatibility only, and should not be used for
   new code.
   
   The following is specifically not supported:
     * flag ' (thousands' grouping character) is recognized but ignored
     * numeric conversion specifiers: f, e, E, g, G and synonym F, as
       well as the new a and A conversion specifiers
     * length modifier 'L' (long double) and 'q' (quad - use 'll'
       instead)
     * wide character/string conversions: lc, ls, and nonstandard
       synonyms C and S
     * writeback of converted string length: conversion character n
     * the n$ specification for direct reference to n-th argument
     * locales
       
   It is permitted for str_m to be zero, and it is permitted to specify
   NULL pointer for resulting string argument if str_m is zero (as per
   ISO C99).
   
   The return value is the number of characters which would be generated
   for the given input, excluding the trailing null. If this value is
   greater or equal to str_m, not all characters from the result have
   been stored in str, output bytes beyond the (str_m-1) -th character
   are discarded. If str_m is greater than zero it is guaranteed the
   resulting string will be null-terminated.
   
   NOTE that this matches the ISO C99, OpenBSD, and GNU C library 2.1,
   but is different from some older and vendor implementations, and is
   also different from XPG, XSH5, SUSv2 specifications. For historical
   discussion on changes in the semantics and standards of snprintf see
   printf(3) man page in the Linux programmers manual.
   
   Routines asprintf and vasprintf return a pointer (in the ptr argument)
   to a buffer sufficiently large to hold the resulting string. This
   pointer should be passed to free(3) to release the allocated storage
   when it is no longer needed. If sufficient space cannot be allocated,
   these functions will return -1 and set ptr to be a NULL pointer. These
   two routines are a GNU C library extensions (glibc).
   
   Routines asnprintf and vasnprintf are similar to asprintf and
   vasprintf, yet, like snprintf and vsnprintf counterparts, will write
   at most str_m-1 characters into the allocated output string, the last
   character in the allocated buffer then gets the terminating null. If
   the formatted string length (the return value) is greater than or
   equal to the str_m argument, the resulting string was truncated and
   some of the formatted characters were discarded. These routines
   present a handy way to limit the amount of allocated memory to some
   sane value.
   
Availability

   http://www.ijs.si/software/snprintf/
     * snprintf_1.3.tar.gz (1999-06-30), md5 sum: snprintf_1.3.tar.gz.md5
     * snprintf_2.1.tar.gz (2000-07-14), md5 sum: snprintf_2.1.tar.gz.md5
     * snprintf_2.2.tar.gz (2000-10-18), md5 sum: snprintf_2.2.tar.gz.md5
       
Mailing list

   There is a very low-traffic mailing list snprintf-announce@ijs.si
   where announcements about new versions will be posted as well as
   warnings about threatening bugs if discovered. The posting is
   restricted to snprintf developer(s).
   
   To subscribe to (or unsubscribe from) the mailing list please visit
   the list server's web page
   http://mailman.ijs.si/listinfo/snprintf-announce
   
   You can also subscribe to the list by mailing the command SUBSCRIBE
   either in the subject or in the message body to the address
   snprintf-announce-request@ijs.si . You will be asked for confirmation
   before subscription will be effective.
   
   The list of members is only accessible to the list administrator, so
   there is no need for concern about automatic e-mail address gatherers.
   
   Questions about the mailing list and concerns for the attention of a
   person should be sent to snprintf-announce-admin@ijs.si
   
   There is no general discussion list about portable snprintf at the
   moment. Please send comments and suggestion to the author.
   
Revision history

   Version 1.3 fixes a runaway loop problem from 1.2. Please upgrade.
   
   1999-06-30 V1.3 Mark Martinec <mark.martinec@ijs.si>
          
          + fixed runaway loop (eventually crashing when str_l wraps
            beyond 2^31) while copying format string without conversion
            specifiers to a buffer that is too short (thanks to Edwin
            Young <edwiny@autonomy.com> for spotting the problem);
          + added macros PORTABLE_SNPRINTF_VERSION_(MAJOR|MINOR) to
            snprintf.h
            
   2000-02-14 V2.0 (never released) Mark Martinec <mark.martinec@ijs.si>
          
          + relaxed license terms: The Artistic License now applies. You
            may still apply the GNU GENERAL PUBLIC LICENSE as was
            distributed with previous versions, if you prefer;
          + changed REVISION HISTORY dates to use ISO 8601 date format;
          + added vsnprintf (patch also independently proposed by Caolán
            McNamara 2000-05-04, and Keith M Willenson 2000-06-01)
            
   2000-06-27 V2.1 Mark Martinec <mark.martinec@ijs.si>
          
          + removed POSIX check for str_m < 1; value 0 for str_m is
            allowed by ISO C99 (and GNU C library 2.1) (pointed out on
            2000-05-04 by Caolán McNamara, caolan@ csn dot ul dot ie).
            Besides relaxed license this change in standards adherence is
            the main reason to bump up the major version number;
          + added nonstandard routines asnprintf, vasnprintf, asprintf,
            vasprintf that dynamically allocate storage for the resulting
            string; these routines are not compiled by default, see
            comments where NEED_V?ASN?PRINTF macros are defined;
          + autoconf contributed by Caolán McNamara
            
   2000-10-06 V2.2 Mark Martinec <mark.martinec@ijs.si>
          
          + BUG FIX: the %c conversion used a temporary variable that was
            no longer in scope when referenced, possibly causing
            incorrect resulting character;
          + BUG FIX: make precision and minimal field width unsigned to
            handle huge values (2^31 <= n < 2^32) correctly; also be more
            careful in the use of signed/unsigned/size_t internal
            variables -- probably more careful than many vendor
            implementations, but there may still be a case where huge
            values of str_m, precision or minimal field could cause
            incorrect behaviour;
          + use separate variables for signed/unsigned arguments, and for
            short/int, long, and long long argument lengths to avoid
            possible incompatibilities on certain computer architectures.
            Also use separate variable arg_sign to hold sign of a numeric
            argument, to make code more transparent;
          + some fiddling with zero padding and "0x" to make it Linux
            compatible;
          + systematically use macros fast_memcpy and fast_memset instead
            of case-by-case hand optimization; determine some breakeven
            string lengths for different architectures;
          + terminology change: format -> conversion specifier, C9x ->
            ISO/IEC 9899:1999 ("ISO C99"), alternative form -> alternate
            form, data type modifier -> length modifier;
          + several comments rephrased and new ones added;
          + make compiler not complain about 'credits' defined but not
            used;
            
Other implementations of snprintf

   I am aware of some other (more or less) portable implementations of
   snprintf. I do not claim they are free software - please refer to
   their respective copyright and licensing terms. If you know of other
   versions please let me know.
     * a very thorough implementation (src/util_snprintf.c) by the Apache
       Group distributed with the Apache web server -
       http://www.apache.org/ . Does its own floating point conversions
       using routines ecvt(3), fcvt(3) and gcvt(3) from the standard C
       library or from the GNU libc.
       This is from the code:
       
     This software [...] was originally based on public domain software
     written at the National Center for Supercomputing Applications,
     University of Illinois, Urbana-Champaign.
     [...] This code is based on, and used with the permission of, the
     SIO stdio-replacement strx_* functions by Panos Tsirigotis
     <panos@alumni.cs.colorado.edu> for xinetd.
     * QCI Utilities use a modified version of snprintf from the Apache
       group.
     * implementations as distributed with OpenBSD, FreeBSD, and NetBSD
       are all wrappers to vfprintf.c, which is derived from software
       contributed to Berkeley by Chris Torek.
     * implementation from Prof. Patrick Powell <papowell@sdsu.edu>,
       Dept. Electrical and Computer Engineering, San Diego State
       University, San Diego, CA 92182-1309, published in Bugtraq
       archives for 3rd quarter (Jul-Aug) 1995. No floating point
       conversions.
     * Brandon Long's <blong@fiction.net> modified version of Prof.
       Patrick Powell's snprintf with contributions from others. With
       minimal floating point support.
     * implementation (src/snprintf.c) as distributed with sendmail -
       http://www.sendmail.org/ is a cleaned up Prof. Patrick Powell's
       version to compile properly and to support .precision and %lx.
     * implementation from Caolán McNamara available at
       http://www.csn.ul.ie/~caolan/publink/snprintf-1.1.tar.gz, handles
       floating point.
     * implementation used by newlog (a replacement for syslog(3)) made
       available by the SOS Corporation. Enabling floating point support
       is a compile-time option.
     * implementation by Michael Richardson <mcr@metis.milkyway.com> is
       available at http://sandelman.ottawa.on.ca/SSW/snp/snp.html. It is
       based on BSD44-lite's vfprintf() call, modified to function on
       SunOS. Needs internal routines from the 4.4 strtod (included),
       requires GCC to compile the long long (aka quad_t) portions.
     * implementation from Tomi Salo <ttsalo@ssh.fi> distributed with SSH
       2.0 Unix Server. Not in public domain. Floating point conversions
       done by system's sprintf.
     * and for completeness: my portable version described in this very
       document available at http://www.ijs.si/software/snprintf/ .
       
   In retrospect, it appears that a lot of effort was wasted by many
   people for not being aware of what others are doing. Sigh.
   
   Also of interest: The Approved Base Working Group Resolution for XSH5,
   Ref: bwg98-006, Topic: snprintf.
     _________________________________________________________________
   
   mm
   Last updated: 2000-10-18
   
   Valid HTML 4.0! 

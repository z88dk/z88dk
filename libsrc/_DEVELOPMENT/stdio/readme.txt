
STDIO
Standard I/O Library

Compliant with ...




FILE STRUCTURE
==============

offset  size  name              purpose

  0      1    JP                z80 jump instruction
  1      2    stdio_next        address of next stdio struct in chain
  3      1    state_flags_0     flags used to hold stream state, described below
  4      1    state_flags_1     flags spillover, described below
  5      1    conversion_flags  flags used by printf converters, described below
  6      1    ungetc            unget char
  7      6    mtx_t file_lock   recursive mutex used for locking file

* state_flags_0

bit   name    purpose

 7    R       if set indicates the stream is open for reading
 6    W       if set indicates the stream is open for writing
 5    0       reserved
 4    eof     if set the input stream reached eof
 3    err     if set the stream encountered an error
210   type    stdio structure type (000 = FILE)

* state_flags_1

bit   name    purpose

 7    cap     if set indicates printf converter should capitalize
 6    sc      if set indicates to printf converter this is a signed conversion
5432  0       reserved
 1    last    if set indicates last stream operation was a read
 0    U       if set indicates there is an ungetc char available

* conversion_flags

bit   name    purpose

 7    N       set by printf converters to indicate negative number
 6    +       if set indicates printf '+' flag
 5    space   if set indicates printf ' ' flag
 4    #       if set indicates printf '#' flag
 3    0       if set indicates printf '0' flag
 2    -       if set indicates printf '-' flag
 1    base    if set indicates octal conversion
 0    P       if set indicates precision was defined 


STDIO_MESSAGES
==============

These are messages sent through the stdio chain.


* STDIO_MSG_PUTC

Output a single char multiple times on the stream.

input:

 A  = STDIO_MSG_PUTC
 E' = char
BC' = number > 0
HL  = number > 0

return:

HL = number of bytes successfully output
carry set if error


* STDIO_MSG_WRIT

Output a buffer on the stream

input:

 A  = STDIO_MSG_WRIT
BC' = length > 0
HL' = void *buffer
HL  = length > 0

return:

HL = number of bytes successfully output
carry set if error

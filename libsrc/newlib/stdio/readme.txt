
STDIO
Standard I/O Library

Compliant with ...




FILE STRUCTURE
==============

offset  size  name              purpose

 -2      2    link              pointer for linked list of FILEs
  0      1    JP                z80 jump instruction
1...2    2    fdstruct          address of connected FDSTRUCT
  3      1    state_flags_0     flags used to hold stream state, described below
  4      1    state_flags_1     flags spillover, described below
  5      1    conversion_flags  flags used by printf converters, described below
  6      1    ungetc            unget char
7..12    6    mtx_t file_lock   recursive mutex used for locking file

* state_flags_0

bit   name    purpose

 7    W       if set indicates the stream is open for writing
 6    R       if set indicates the stream is open for reading
 5    D       if set indicates the driver handles ungetc for eatc message
 4    eof     if set the input stream reached eof
 3    err     if set the stream encountered an error
210   type    stdio structure type (000 = FILE, 111 = MEMSTREAM)
            
* state_flags_1

bit   name    purpose

 7    cap     if set indicates printf converter should capitalize
 6    sc      if set indicates to printf converter this is a signed conversion
5432  0       reserved
 1    last    if set indicates last stream operation was a read
 0    U       if set indicates there is an ungetc char available

* conversion_flags

(PRINTF ONLY)

bit   name    purpose

 7    N       set by printf converters to indicate negative number
 6    +       if set indicates printf '+' flag
 5    space   if set indicates printf ' ' flag
 4    #       if set indicates printf '#' flag
 3    0       if set indicates printf '0' flag
 2    -       if set indicates printf '-' flag
 1    base    if set indicates octal conversion
 0    P       if set indicates precision was defined 


MEMORY STREAM FILE STRUCTURE
============================

offset  size  name              purpose

 -2       2   link              pointer for linked list of FILEs
  0      13   FILE              FILE structure not including link
  13      1   memstream_flags   see below
14..15    2   char **bufp       where to store buffer address
16..17    2   size_t *sizep     where to store buffer length
18..25    8   b_vector          byte vector to manage resizeable buffer
26..27    2   fp                file pointer index (index in vector for next read/write)
  28      1   mode              mode byte when memstream was created (for freopen() )

* memstream_flags

bit   name    purpose

 7     F      if set buffer is freed when file is closed
 6     0      reserved
 5     X      if set buffer info is written on flush
 4     0      reserved
 3     0      reserved
 2     A      if set writes append
 1     0      reserved
 0     0      reserved



STDIO_MESSAGES
==============

These are messages sent through the stdio chain.


****************
* STDIO_MSG_PUTC
****************

Output a single char multiple times on the stream.

input:

 A  = STDIO_MSG_PUTC
 E' = char
BC' = number > 0
HL  = number > 0

return:

HL = number of bytes successfully output
carry set if error

****************
* STDIO_MSG_WRIT
****************

Write the buffer to the stream

input:

 A  = STDIO_MSG_WRIT
BC' = length > 0
HL' = void *buffer = byte source
HL  = length > 0

return:

HL'= void *buffer + num bytes written
HL = number of bytes successfully output
carry set if error

****************
* STDIO_MSG_GETC
****************

Read a single character from the stream

input:

 A = STDIO_MSG_GETC

return:

A = HL = char
carry set on error or eof: if HL=0 stream error, HL=-1 on eof

****************
* STDIO_MSG_EATC
****************

Remove matching characters from the stream

input:

 A = STDIO_MSG_EATC
HL'= int (*qualify)(char c)
BC'= optional
DE'= optional
HL = max_length = number of stream chars to consume

return:

BC = number of bytes consumed from stream
HL = next unconsumed (unmatching) char or EOF
BC'= unchanged by driver
DE'= unchanged by driver
HL'= unchanged by driver

carry set on error or eof: if HL=0 stream error, HL=-1 on eof

note: Characters are consumed from the stream until the qualify
function returns with carry flag set or until max_length
chars are consumed from the stream.

The qualify function owns the bc, de, and hl registers but
must not alter any others.

****************
* STDIO_MSG_READ
****************

Read stream characters into a buffer

input:

 A = STDIO_MSG_READ
DE'= void *buffer = byte destination
BC'= max_length > 0
HL = max_length > 0

return:

BC = number of bytes successfully read
DE'= void *buffer_ptr = address of byte following last written

carry set on error with HL=0 for stream err, HL=-1 for eof

****************
* STDIO_MSG_SEEK
****************

Move file pointer to new position

input:

   A = STDIO_MSG_SEEK
   C = STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
DEHL'= file offset
   C'= STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)

return:

DEHL = updated file position
carry set on error (file position out of range)

note: stdio stages with buffers must flush first when
this message is received.

****************
* STDIO_MSG_ICTL
****************

IOCTL message delivery to driver

input:

   A = STDIO_MSG_ICTL
  BC = first parameter
  DE = ioctl request
  HL = void *arg, C argument list (must mind L->R or R->L param order!)

condition:

  do not alter EXX registers

output:

  carry reset if ok, HL = return value != -1
  carry set if fail

****************
* STDIO_MSG_FLSH
****************

Flush the file.

If the last operation was a write, send the contents
of any output buffers to the file.  If a stream
error occurs, this may only be partially accomplished.

If the last operation was a read, unread any unconsumed
buffers by seeking backwards.  It is not possible
to seek prior to position 0 and this operation always
succeeds.

input:

 A = STDIO_MSG_FLSH

return:

carry set on error (write buffers could not be flushed)

****************
* STDIO_MSG_CLOS
****************

Flush message is always sent before close.
Perform any cleanup.

input:

 A = STDIO_MSG_CLOS

return:

carry set if error occurred



A small circular byte buffer.  Buffer size must be a power of 2 less than
256 bytes (ie 2, 4, 8, ... , 128 bytes).  The buffer must be dynamically
or statically allocated elsewhere and its address stored in the scbb0
data structure.

One simultaneous reader and writer is supported without any
synchronization.  An example application is a key buffer with the reader
being the tty driver consuming keypresses and the writer being the
keyboard driver delivering keypresses.

The scbb0 data structure:

offset   size    description

  +0      1      ravail (# available bytes for reading + $80)
  +1      1      mask   (buffer size - 1)
  +2      1      rptr   (offset where next char is to be read from)
 +3/4     2      buffer (base buffer address)
  +5      1      wptr   (offset where next char is to be written)
  +6      1      mask   (buffer size - 1)
  +7      1      wavail (space in buffer available for writing + $80)

Functions:

* scbb0_initbuf

As scbb0_resetbuf but also stores buffer size.

* scbb0_resetbuf

Clear the buffer to empty.  Does not alter the buffer address already
stored in the data structure.

* scbb0_isempty

Returns true if no chars are available for reading.

* scbb0_isfull

Returns true if there is no more room to write chars to the buffer.

* scbb0_peekchar

Returns the next char to be read without removing it from the buffer.

* scbb0_readchar

Reads the next char from the buffer and removes it.

* scbb0_writechar

Writes a char to the end of the buffer.


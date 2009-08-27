
A small linear byte buffer.  Buffer size must be less than 256 bytes.  The
buffer must be dynamically or statically allocated elsewhere and its address
stored in the slbb0 data structure.

This buffer type keeps track of the amount of data stored in the buffer as
well as the buffer's size.  It allows insertion and removal of a byte from
the data portion of the buffer, causing the buffer contents to be copied
using ldir to fill or remove the resulting hole.  An example application is
an edit-line buffer.  Buffer functions allow individual text characters to
be inserted or deleted from the line being edited.

The slbb0 data structure:

offset   size    description

  +0      1      end    (index of first unoccupied position in buffer)
  +1      1      len    (length of buffer in bytes)
 +2/3     2      buffer (base buffer address)

Functions:

* slbb0_initbuf

Initialize the buffer to empty and store buffer address and size

* slbb0_resetbuf

Clear buffer to empty

* slbb0_isempty

Return true if the buffer is empty

* slbb0_isfull

Return space remaining in buffer and indicate whether the buffer is full

* slbb0_checkindex

Indicate whether an index is in bounds, ie points at data stored in the buffer

* slbb0_readchar

Read a character from the indicated buffer index

* slbb0_writechar

Write a character to the indicated buffer index

* slbb0_appendchar

Add a char to the end of the buffer

* slbb0_insertchar

Insert a char prior to the indicated buffer index, copying buffer data one
spot forward to make room

* slbb0_addchar

Add a char after the indicated buffer index, copying buffer data one spot
forward to make room

* slbb0_removechar

Return the character at the specific buffer index and remove it from the
buffer by copying buffer data one spot backward to fill the hole


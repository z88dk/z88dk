
This directory contains code for various types of buffers.

Reuse by device drivers is encouraged to help minimize the output memory
footprint.  If your needs are not met by any buffer found here, please
consider isolating your buffer code and submitting it here for use by
others.

Details on each buffer type can be found in the subdirectories.  A brief
listing can be found below.

** scbb0 - small circular byte buffer

A circular byte buffer whose size must be a power of 2 less than 256.
The buffer itself must be dynamically allocated (or statically supplied)
and its address stored in the scbb0 data structure.  Supports one
reader and one writer simultaneously without any synchronization.

Used by: tty0 (keyboard push mode)


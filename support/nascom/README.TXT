NASCOM 1 and 2 libraries.

The code should work with both NASSYS and T MONITOR, and the 
code is located by default at $0C80.
The ANSI version of the library depends a bit less on the ROM 
because the video memory is addressed directly.

To compile and run a program:

zcc +nascom program.c
bin2nas a.bin program.nas
vnascom ROM=nassys1.nas RAM=tic.nas KBD=EC80

Variants on this might be the use of the "nasansi" library 
or another emulator; the NAS format is somehow universal.


DEVICE DRIVERS


Device drivers are object-oriented with architecture-specific drivers
inheriting code from base classes supplied by the library.  The code
inheritance mechanism allows similar device drivers to share code.


Device drivers are divided into three main types:

* Block

The device generates i/o in record units.  A record is a block of bytes.
Examples include floppy disk, hard disk and sd card.

* Character

The device generates i/o in a character-at-a-time fashion.
Examples include serial i/o, parallel i/o and network.

* Terminal

A pairing of a character-oriented ouput device and a character-oriented
input device that is intended for interaction with the user.  Terminals
are a special type of character device that allow tieing together an
output device and an input device and can allow editing of the input.
Examples include keyboard and crt.


Architecture-specific drivers can be found in 'arch/{target}'.

The other subdirectories contain library code to support the writing
of device drivers of the various types.


This directory contains keyboard drivers for the various targets supported
by z88dk.  These are physical device drivers and there should be exactly
one keyboard driver present in any compile for each physical keyboard
device being used by the program.

A keyboard driver can be one of two types: push or pull.  Push drivers
asynchronously read the keyboard and push each keypress to an attached
tty driver by calling a receiving function within the driver.  Pull
drivers are passive and are called by the tty driver whenever it needs
keyboard input.

Examples of a push driver might include a PS/2 keyboard that generates
an interrupt for each keypress.  The keyboard's ISR pushes the key
read to an attached tty driver by calling a function within the driver.
The tty driver will queue the keypress in an internal buffer and return.

Another example of a push driver could include a passive keyboard read
during a regular interrupt.  If a keypress is detected during the
interrupt, it is pushed to an attached tty driver by calling a function
within the driver.

Push drivers perform much better and if possible targets should aim
to supply push drivers.  Pull drivers can only deliver one keypress at
a time to the tty driver and in most cases must contain delay code to
prevent a large number of keypress detections in a short time.

A program can create multiple instances of a tty driver.  Each instance
of a tty driver is associated with one text window.  If, as in most cases,
the target only has one physical keyboard, only one tty driver should be
receiving keyboard data at a time.  The tty driver receiving input is
kept track of by the keyboard driver with its storage of the function
address to call when pushing keyboard data.  Changing the tty window
receiving key input is a simple matter of changing the push function
address.  tty drivers can be queried for their push function address
with a standard ioctl() query.

Aside from interfacing with tty drivers, the keyboard driver should
supply functions to asynchronously read the instantaneous state of the
keyboard.

The full set of functions a target's keyboard driver should supply to
be fully compliant with z88dk's keyboard model is listed below:

jksdfjdsfjks

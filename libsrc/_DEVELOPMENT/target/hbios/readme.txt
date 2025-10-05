
==========
ARCH HBIOS
==========

Directory structure containing architecture-specific primitives. These primitives either access the hbios calling routines, present in the ROMWBW platform (for many hardware platforms).

HBIOS functions are invoked by placing the required parameters in CPU registers and executing an RST 08 instruction (or call 0xFFF0).

Note that HBIOS does not preserve register values that are unused.

However, HBIOS must not modify the Z80 alternate registers or IX/IY (these registers can be used within HBIOS as long as they are saved and restored internally).

Some HBIOS functions utilize pointers to memory buffers. Such memory buffers are required to be located in the upper 32K for CPU RAM address space. This requirement significantly simplifies the HBIOS proxy and improves performance by avoiding “double copies” of buffers.

In general, the desired function is placed in the B register. Register C is frequently used to specify a subfunction or a target device number. Additional registers are used as defined by the specific function. Register A should be used to return function result information. A=0 should indicate success, other values are function specific.

Normally, applications will not call HBIOS functions directly. It is intended that the operating system makes all HBIOS function calls. Applications that are considered system utilities may use HBIOS, but must be careful not to modify the operating environment in any way that the operating system does not expect.


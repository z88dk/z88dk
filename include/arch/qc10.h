#ifndef __ARCH_QX10_H__
#define __ARCH_QX10_H__

#include <sys/compiler.h>
#include <stdlib.h>

///////////////////////////
//   EPSON QC-10 or QX-10 
///////////////////////////

// Check if the Colour monitor is connected
#define qc10_have_color()  (inp(0x2c)==0xfd)

// Determine if the program is running on an Epson QX-10 or QC-10
// checking for a green or color monitor
#define is_qc10()  ((inp(0x2c)==0xfe)||(inp(0x2c)==0xfd)))

// Have BIOS in ($f603) ?
#define qc10_m1bios()  (wpeek(1)==(-2557))

#endif

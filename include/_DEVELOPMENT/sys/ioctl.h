
#ifndef _SYS_IOCTL_H
#define _SYS_IOCTL_H

#include <stdint.h>

#define IOCTL_ITERM_ECHO 0x0081
#define IOCTL_ITERM_PASS 0x0041
#define IOCTL_ITERM_LINE 0x0021
#define IOCTL_ITERM_COOK 0x0011
#define IOCTL_ITERM_CAPS 0x0009
#define IOCTL_ITERM_SETF 0x00f9

#define IOCTL_OTERM_COOK 0x0012
#define IOCTL_OTERM_SETF 0x00fa

#ifdef __SDCC

// SDCC

extern int      _ioctl_(FILE *stream, uint16_t command, ...);
extern int      _vioctl_(FILE *stream, uint16_t command, void *arg);

extern int      _ioctl__unlocked(FILE *stream, uint16_t command, ...);
extern int      _vioctl__unlocked(FILE *stream, uint16_t command, void *arg);

#else

// SCCZ80

extern int __LIB__            _ioctl_(FILE *stream, uint16_t command, ...);
extern int __LIB__            _vioctl_(FILE *stream, uint16_t command, void *arg);

extern int __LIB__            _ioctl__unlocked(FILE *stream, uint16_t command, ...);
extern int __LIB__            _vioctl__unlocked(FILE *stream, uint16_t command, void *arg);

// SCCZ80 CALLEE LINKAGE

extern int __LIB__ __CALLEE__ _vioctl__callee(FILE *stream, uint16_t command, void *arg);
extern int __LIB__ __CALLEE__ _vioctl__unlocked_callee(FILE *stream, uint16_t command, void *arg);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define _vioctl_(a,b,c)                _vioctl__callee(a,b,c)
#define _vioctl__unlocked(a,b,c)       _vioctl__unlocked_callee(a,b,c)

#endif


#endif

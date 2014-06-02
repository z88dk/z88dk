
#ifndef _SYS_IOCTL_H
#define _SYS_IOCTL_H

#include <stdint.h>

#define IOCTL_ITERM_ECHO 0xc081
#define IOCTL_ITERM_PASS 0xc041
#define IOCTL_ITERM_LINE 0xc021
#define IOCTL_ITERM_COOK 0xc011
#define IOCTL_ITERM_CAPS 0xc009
#define IOCTL_ITERM_CRLF 0xc101
#define IOCTL_ITERM_CURS 0xc201

#define IOCTL_ITERM_SETF 0xbff9
#define IOCTL_ITERM_STFM 0x8001
#define IOCTL_ITERM_GETF 0x7ff9
#define IOCTL_ITERM_GTFM 0x4001

#define IOCTL_OTERM_COOK 0xc012

#define IOCTL_OTERM_SETF 0xbffa
#define IOCTL_OTERM_STFM 0x8002
#define IOCTL_OTERM_GETF 0x7ffa
#define IOCTL_OTERM_GTFM 0x4002

#define IOCTL_OTERM_FONT 0x0002

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

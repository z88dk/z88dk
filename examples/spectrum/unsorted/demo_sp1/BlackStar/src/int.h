#ifndef _INT_H
#define _INT_H

#ifndef WFRAMES
#define WFRAMES  4
#endif

#define clock(x) (tick)

extern unsigned char tick;

extern void wait(void);
extern void setup_int(void);

#endif

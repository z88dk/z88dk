#ifndef __MICROC_H__
#define __MICROC_H__

/*
 *	Dave Dunfield Systems Micro C compatibility lib
 */

#include <stdlib.h>
#include <fcntl.h>
#include <ctype.h>
#include <setjmp.h>
#include <string.h>
#include <time.h>
#include <sound.h>
#include <math.h>
#undef abort

#define abort(a) exit(puts_cons(a)&0)

#define getstr(s,l)         fgets_cons(s,l)
#define putstr(s)           puts_cons(s)
#define fget(buf,size,fd)   read(fd, buf, size);
#define fput(buf,size,fd)   write(fd, buf, size);

#define atox(ptr) stroul(ptr,NULL,16)
#define beep(freq, duration)  bit_frequency(duration, frequency)



#define RAND_SEED std_seed

#define random(a) rand()%a
#define get_time(a,b,c)  *a=(clock()/CLOCKS_PER_SEC*3600); *b=(clock()/CLOCKS_PER_SEC*60); *c=(clock()/CLOCKS_PER_SEC)

#endif


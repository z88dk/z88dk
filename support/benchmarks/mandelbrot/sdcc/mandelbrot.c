/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/

   contributed by Greg Buchholz
   
   for the debian (AMD) machine...
   compile flags:  -O3 -ffast-math -march=athlon-xp -funroll-loops

   for the gp4 (Intel) machine...
   compile flags:  -O3 -ffast-math -march=pentium4 -funroll-loops
*/

/*
 * COMMAND LINE DEFINES
 *
 * -DSTATIC
 * Use statics instead of locals.
 *
 * -DPRINTF
 * Enable printing of results.
 *
 * -DTIMER
 * Insert asm labels into source code at timing points (Z88DK).
 *
 * -DCOMMAND
 * Enable reading of N from the command line.
 *
 */

#ifdef STATIC
   #undef  STATIC
   #define STATIC            static
#else
   #define STATIC
#endif

#ifdef PRINTF
   #define PRINTF3(a,b,c)    printf(a,b,c)
   #define PUTC(a,b)         putc(a,b)
#else
   #define PRINTF3(a,b,c)
   #define PUTC(a,b)         (*output++ = a)
#endif

#ifdef TIMER
   #define TIMER_START()       __asm__("TIMER_START:")
   #define TIMER_STOP()        __asm__("TIMER_STOP:")
#else
   #define TIMER_START()
   #define TIMER_STOP()
#endif

#ifdef __Z88DK
   #include <intrinsic.h>
   #ifdef PRINTF
      // enable printf %d
	   #pragma output CLIB_OPT_PRINTF = 0x01
   #endif
#endif


#include<stdio.h>

unsigned char *output = (unsigned char *)0xc000;

int main (int argc, char **argv)
{
    STATIC int w, h, bit_num;
    STATIC unsigned char byte_acc;
    STATIC int i;
	 STATIC int iter = 50;
    STATIC double x, y;
    STATIC double Zr, Zi, Cr, Ci, Tr, Ti;
    STATIC double limit = 2.0;

#ifdef COMMAND
    w = argc > 1 ? atoi(argv[1]) : 60;
	 h = argc > 2 ? atoi(argv[2]) : w;
#else
    w = h = 60;
#endif

    PRINTF3("P4\n%d %d\n",w,h);

TIMER_START();

    for(y=0;y<h;++y) 
    {
        for(x=0;x<w;++x)
        {
            Zr = Zi = Tr = Ti = 0.0;
            Cr = (2.0*x/w - 1.5); Ci=(2.0*y/h - 1.0);
        
            for (i=0;i<iter && (Tr+Ti <= limit*limit);++i)
            {
                Zi = 2.0*Zr*Zi + Ci;
                Zr = Tr - Ti + Cr;
                Tr = Zr * Zr;
                Ti = Zi * Zi;
            }
       
            byte_acc <<= 1; 
            if(Tr+Ti <= limit*limit) byte_acc |= 0x01;
                
            ++bit_num; 

            if(bit_num == 8)
            {
                PUTC(byte_acc,stdout);
                byte_acc = 0;
                bit_num = 0;
            }
            else if(x == w-1)
            {
                byte_acc <<= (8-w%8);
                PUTC(byte_acc,stdout);
                byte_acc = 0;
                bit_num = 0;
            }
        }
    }

TIMER_STOP();
}

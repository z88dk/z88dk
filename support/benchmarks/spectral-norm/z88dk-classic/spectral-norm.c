/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * Contributed by Sebastien Loisel
 */

#ifdef STATIC
   #undef  STATIC
   #define STATIC            static
#else
   #define STATIC
#endif

#ifdef PRINTF
   #define PRINTF2(a,b)      printf(a,b)
#else
   #define PRINTF2(a,b)      b
#endif

#ifdef TIMER
   #ifdef __80CC
      #define TIMER_START()     __asm__("TIMER_START:")
      #define TIMER_STOP()      __asm__("TIMER_STOP:")
   #else
      #define TIMER_START()     intrinsic_label(TIMER_START)
      #define TIMER_STOP()      intrinsic_label(TIMER_STOP)
   #endif
#else
   #define TIMER_START()
   #define TIMER_STOP()
#endif

#ifdef __Z88DK
   #include <intrinsic.h>
#endif

#ifdef __MATH_MATH16
    #define DOUBLE          _Float16
#else
    #define DOUBLE          double
#endif

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define NUM 100

DOUBLE eval_A(int i, int j)
{
    /* Cast so sccz80 uses f16 under --math16; bare 1.0 is f48 (ddiv). */
    return (DOUBLE)1.0/(DOUBLE)((i+j)*(i+j+1)/2+i+1);
}

void eval_A_times_u(const DOUBLE u[], DOUBLE Au[])
{
  STATIC int i,j;
  for(i=0;i<NUM;i++)
    {
      Au[i]=0;
      for(j=0;j<NUM;j++) Au[i]+=eval_A(i,j)*u[j];
    }
}

void eval_At_times_u(const DOUBLE u[], DOUBLE Au[])
{
  STATIC int i,j;
  for(i=0;i<NUM;i++)
    {
      Au[i]=0;
      for(j=0;j<NUM;j++) Au[i]+=eval_A(j,i)*u[j];
    }
}

void eval_AtA_times_u(const DOUBLE u[], DOUBLE AtAu[])
{
    static DOUBLE v[NUM];

    eval_A_times_u(u,v);
    eval_At_times_u(v,AtAu);
}

int main(void)
{
  STATIC int i;
  STATIC DOUBLE u[NUM],v[NUM],vBv,vv;

TIMER_START();

  for(i=0;i<NUM;i++) u[i]=1;
  for(i=0;i<10;i++)
    {
      eval_AtA_times_u(u,v);
      eval_AtA_times_u(v,u);
    }
  vBv=vv=0;
  for(i=0;i<NUM;i++) { vBv+=u[i]*v[i]; vv+=v[i]*v[i]; }
#ifdef __MATH_MATH16
  PRINTF2("%0.9f\n",sqrtf16(vBv/vv));
#else
  PRINTF2("%0.9f\n",sqrt(vBv/vv));
#endif

TIMER_STOP();

  return 0;
}

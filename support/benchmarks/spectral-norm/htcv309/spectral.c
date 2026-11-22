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
#define TIMER_START()     intrinsic_label(TIMER_START)
#define TIMER_STOP()      intrinsic_label(TIMER_STOP)
#else
#define TIMER_START()
#define TIMER_STOP()
#endif


#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define NUM 100

double eval_A(int i, int j)
{
	return 1.0/((i+j)*(i+j+1)/2+i+1);
}

void eval_A_times_u(double u[], double Au[])
{
  STATIC int i,j;
  for(i=0;i<NUM;i++)
    {
      Au[i]=0;
      for(j=0;j<NUM;j++) Au[i]+=eval_A(i,j)*u[j];
    }
}

void eval_At_times_u(double u[], double Au[])
{
  STATIC int i,j;
  for(i=0;i<NUM;i++)
    {
      Au[i]=0;
      for(j=0;j<NUM;j++) Au[i]+=eval_A(j,i)*u[j];
    }
}

void eval_AtA_times_u(double u[], double AtAu[])
{
	static double v[NUM];
	
	eval_A_times_u(u,v);
	eval_At_times_u(v,AtAu);
}

int main(void)
{
  STATIC int i;
  STATIC double u[NUM],v[NUM],vBv,vv;

TIMER_START();

  for(i=0;i<NUM;i++) u[i]=1;
  for(i=0;i<10;i++)
    {
      eval_AtA_times_u(u,v);
      eval_AtA_times_u(v,u);
    }
  vBv=vv=0;
  for(i=0;i<NUM;i++) { vBv+=u[i]*v[i]; vv+=v[i]*v[i]; }
  PRINTF2("%0.9f\n",sqrt(vBv/vv));

TIMER_STOP();

  return 0;
}

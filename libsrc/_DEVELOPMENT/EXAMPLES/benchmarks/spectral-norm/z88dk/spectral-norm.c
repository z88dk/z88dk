/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * Contributed by Sebastien Loisel
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define NUM 2000

double eval_A(int i, int j)
{
	return 1.0/((i+j)*(i+j+1)/2+i+1);
}

void eval_A_times_u(const double u[], double Au[])
{
  STATIC int i,j;
  for(i=0;i<NUM;i++)
    {
      Au[i]=0;
      for(j=0;j<NUM;j++) Au[i]+=eval_A(i,j)*u[j];
    }
}

void eval_At_times_u(const double u[], double Au[])
{
  STATIC int i,j;
  for(i=0;i<NUM;i++)
    {
      Au[i]=0;
      for(j=0;j<NUM;j++) Au[i]+=eval_A(j,i)*u[j];
    }
}

void eval_AtA_times_u(const double u[], double AtAu[])
{
	static double v[NUM];
	
	eval_A_times_u(u,v);
	eval_At_times_u(v,AtAu);
}

int main(void)
{
  STATIC int i;
  STATIC double u[NUM],v[NUM],vBv,vv;
  
  for(i=0;i<NUM;i++) u[i]=1;
  for(i=0;i<10;i++)
    {
      eval_AtA_times_u(u,v);
      eval_AtA_times_u(v,u);
    }
  vBv=vv=0;
  for(i=0;i<NUM;i++) { vBv+=u[i]*v[i]; vv+=v[i]*v[i]; }
  printf("%0.9f\n",sqrt(vBv/vv));
  return 0;
}

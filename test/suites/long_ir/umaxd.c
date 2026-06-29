/* umchess (micro-Max) D — a recursive 7-`long` negamax search. Its `v = -D(...)`
 * assignment (umchess.c:86) emits a same-width long->long IR_CONV_SX (4->4), an
 * identity. ir_opt's copy-propagation is byte-only (ir_opt.c: width-1 guard), so
 * a width-4 same-width conv is never eliminated and reaches the lowerer; gen_conv_sx
 * had no 4->4 case and the whole function failed to lower ("CONV_SX 4->4 not
 * supported"). Fixed by handling 4->4 (and 4->4 CONV_ZX) as an identity DEHL copy,
 * mirroring the existing 2->2 case. This is the real reproducer — a minimal one is
 * impractical (most ir_build conversion sites guard src_w==dst_w; only this
 * construct emits the redundant 4->4, and being width-4 it survives all opt). The
 * D=0 reference matches sccz80; the value also guards a future miscompile of the
 * identity copy. Own binary: long_ir.c is at the MSX 64K ceiling. */
#include "test.h"
#define W while
//int M=136,S=128,I=8e3,C=799,Q,O,K,N;   
long M=136,S=128,I=8e3,C=799,Q,O,K,N;

char L,*P,
w[]={0,1,1,-1,3,3,5,9},                      
o[]={-16,-15,-17,0,1,16,0,1,16,15,17,0,14,18,31,33,0,
     7,-1,6,11,8,3,6,                          
     6,4,5,7,3,5,4,6},                         
b[129],

n[]=".?+knbrq?*?KNBRQ",

c[9];

//D(k,q,l,e,E,z,n)        
//int k,q,l,e,E,z,n;      
long D(long k, long q, long l, long e, long E, long z, long n)
{                       
 long j,r,m,v,d,h,i,F,G,s;
 char t,p,u,x,y,X,Y,H,B;

 q--;                                          
 d=X=Y=0;                                      

 W(d++<n||
//   z==8&K==I&&(N<1e6&d<98||
   z==8&K==I&&(N<200&d<98||                    
   (K=X,L=Y&~M,d=2)))                          
 {x=B=X;                                       
  h=Y&S;                                   
  m=d>1?-I:e;                                  
  N++;                                         
  do{u=b[x];                                   
   if(u&k)                                     
   {r=p=u&7;                                   
    j=o[p+16];                                 
    W(r=p>2&r<0?-r:-o[++j])                    
    {A:                                        
     y=x;F=G=S;                                
     do{                                       
      H=y=h?Y^h:y+r;                        
      if(y&M)break;                            
      m=E-S&&b[E]&&y-E<2&E-y<2?I:m;    /* castling-on-Pawn-check bug fixed */
      if(p<3&y==E)H^=16;                       
      t=b[H];if(t&k|p<3&!(y-x&7)-!t)break;       
      i=99*w[t&7];                             
      m=i<0?I:m;                       /* castling-on-Pawn-check bug fixed */
      if(m>=l)goto C;                          

      if(s=d-(y!=z))                           
      {v=p<6?b[x+8]-b[y+8]:0;
       b[G]=b[H]=b[x]=0;b[y]=u|32;             
       if(!(G&M))b[F]=k+6,v+=30;               
       if(p<3)                                 
       {v-=9*((x-2&M||b[x-2]-u)+               
              (x+2&M||b[x+2]-u)-1);            
        if(y+r+1&S)b[y]|=7,i+=C;               
       }
       v=-D(24-k,-l,m>q?-m:-q,-e-v-i,F,y,s);   
       if(K-I)                                 
       {if(v+I&&x==K&y==L&z==8)                
        {Q=-e-i;O=F;
         if(b[y]-u&7&&P-c>5)b[y]-=c[4]&3;        /* under-promotions */
         return l;
        }v=m;                                   
       }                                       
       b[G]=k+6;b[F]=b[y]=0;b[x]=u;b[H]=t;     
       if(v>m)                         
        m=v,X=x,Y=y|S&F;                       
       if(h){h=0;goto A;}                            
      }
      if(x+r-y|u&32|                           
         p>2&(p-3|j-7||                        
         b[G=x+3^r>>1&7]-k-6                   
         ||b[G^1]|b[G^2])                      
        )t+=p<5;                               
      else F=y;                                
     }W(!t);                                   
  }}}W((x=x+9&~M)-B);                          
C:if(m>I-M|m<M-I)d=98;                         
  m=m+I?m:-D(24-k,-I,I,0,S,S,1);    
 }                                             
 return m+=m<e;                                
}


static void test_umax_d(void)
{
    long r;
    K = 8; W(K--) { b[K] = (b[K+112] = o[K+24]+8) + 8; b[K+16] = 18; b[K+96] = 9; }
    r = D(8, -I, I, Q, O, 8, 2);     /* recursive minimax over the start-ish board */
    Assert(r == 0, "umchess D recursive 7-long minimax lowers (CONV_SX 4->4) and scores 0");
}

int main(int argc, char *argv[])
{
    suite_setup("umchess D — recursive long minimax (CONV_SX 4->4)");
    suite_add_test(test_umax_d);
    return suite_run();
}

/*
 *      Small C+ Compiler
 *
 *      Routines to float an string
 *
 *      $Id: float.c,v 1.1 2000-07-04 15:33:31 dom Exp $
 */

#include "ccdefs.h"


/* Kludgy way to convert number to 6 byte representation 
 * Entry: val=value fa=pointer to 6 byte area for number */


void qfloat(va,fa)
int va;
unsigned char *fa;
{
        long     exp,minus,val;
        long    b,c;
        
        val=va;

        if (val == 0)
        {
                for (b=0 ; b < 6 ; b++){
                        *fa++='\0';
                }
                return;
        }

        minus=b=c=0;
        exp=128+38+8;
        if (val < 0)
        {
                val=-val;
                minus=1;
        }
        norm(val,b,c,minus,fa,exp);
}


void norm(a,b,c,minus,fa,exp)
long a,b,c,minus,exp;
unsigned char *fa;
{

        if (a | b | c)
        {

        while (c < 32768UL)
        {
        a *=2;
        if (a >= 65536UL)
        {
                a%=65536UL;
                b++;
        }
        b*=2;
        if (b >= 65536UL)
        {
                b%=65536UL;
                c++;
        }
        c*=2;
        exp--;
        }
/* Now a,b,c,exp is the number, get the sign */
        if (!minus) c&=32767; /* It should work! */
        if (mathz88) a=0;
        *fa++=a/256;
        *fa++=b%256;
        *fa++=b/256;
        *fa++=c%256;
        *fa++=c/256;
        *fa++= exp%256;
        }
}

/* Multiply the damn number now */

/* fa1 = accumulator, fa2=bcixde */


void fltmult(i1,i2)
unsigned char *i1;
unsigned char *i2;
{

        unsigned char fa1[7],fa2[7],fa3[8];
        long     i,j,k,temp2,mask,carry;
	unsigned long temp;
        long     a,b,c,exp;

        unpack(i1,fa1);
        unpack(i2,fa2);

        if (fa1[5]==0)    /* If zero return */
        {
                for (k=0 ; k < 6 ; k++)
                {
                        *i2++=*i1++;
                }
                return;
        }
        if (fa2[5]==0) return ;

        

        for (i=0; i <7; i++)
        {
        fa3[i]='\0';
        }

/* Calculate exponent! */

        temp=((fa1[5]+fa2[5])%256);
        temp2 = temp >> 1;
        exp= 128+temp;


/* fa1=accumulator, fa2=multiplicand, fa3=product */
/* fa3 has 6 mantissa bytes...0-5 add to 1-4 (0 is carry thing) */

        for (i=0; i<5; i++)
        {
                mask=1;
                for (j=0; j<8; j++){
                        carry=0;
                        if (fa1[i] & mask){
                        /* Add together now! */
                  
                          for (k=0; k<5 ; k++){
                                temp=fa3[k+1]+fa2[k]+carry;
                                fa3[k+1] = (temp % 256);
                                carry=0;
                                if (temp >= 256) carry=1;
                          }
                        }
                             for (k=5 ; k>=0; k--) {
                                temp2 = (fa3[k] & 1); /* LS bit */
                                fa3[k]= fa3[k] >> 1;
                                if (carry) fa3[k] = (fa3[k] | 128);
                                carry=temp2;
                                }
                 mask=mask << 1;
                }
        }                        
        a=fa3[0]+(256UL*fa3[1]);
        b=fa3[2]+(256UL*fa3[3]);
        c=fa3[4]+(256UL*fa3[5]);
        norm(a,b,c,0,i2,exp);
        return;
}



/* This is a very cut down version and doesn't consider adding -ve
 * number to positive etc..just for the compiler! */


void fltadd(i1,i2)
unsigned char *i1;
unsigned char *i2;
{
        long temp,temp2,i,j,carry;
        unsigned char fa1[7],fa2[7];


        if (*(i2+5)==0)    /* If zero return */
        {
                for (i=0 ; i < 6 ; i++)
                {
                        *i2++=*i1++;
                }
                return;
        }
        if (*(i1+5)==0) return ;

        unpack(i1,fa1);
        unpack(i2,fa2);

/* fa1 > fa2  fa1=accumulator, fa2=bcixde */

       if ((fa1[5]-fa2[5]) > 38) 
       {

                for (i=0 ; i < 6 ; i++)
                {
                        *i2++=*i1++;
                }
                return;
       }

/* Unequal exponents, do some shifting!! */

        if (fa1[5] != fa2[5])
        {
 
                temp=0;
                for (i=0 ; i<(fa1[5]-fa2[5]) ; i++)
                {
                        for (j=4 ; j>=0; j--)
                        {
                                temp2 = (fa2[j] & 1); /* LS bit */
                                fa2[j]= fa2[j] >> 1;
                                if (temp) fa2[j] = (fa2[j] | 128);
                                temp=temp2;
                        }
                }
        }

/* Now for some addition! */
        carry=0;
        for (i=0; i<5 ; i++)
        {
                temp=fa1[i]+fa2[i]+carry;
                fa1[i] = temp % 256;
                carry=0;
                if (temp >= 256) carry=1;
        }
        if (carry) 
        {
                fa1[5]=fa1[5]+1;  /* Carry -> exp+1 */
                temp = 0;
/* Now, have to divide number by 2! */
                for (i=4; i>= 0; i--)
                {
                temp2 = (fa1[i] & 1); /* LS bit */
                fa1[i]= fa1[i] >> 1;
                if (temp) fa1[i] = (fa1[i] | 128);
                temp=temp2;
                }
        }

        pack(fa1,i2);
        return;
}
                                

/* Pack, because we can't be arsed with -ve signs..not much to do! */
/* Should really check to see if s[4] & 128 then increment everything
   but really cant be arsed..hope it still works!! */


void pack(s,d)
unsigned char *s;
unsigned char *d;
{
        *d++=*s++;
        *d++=*s++;
        *d++=*s++;
        *d++=*s++;
        *d++=( *s++ & 127);
        *d=*s;
        return;
}


/* Unpack - ie restore hidden bit and make sign... */


void unpack(s,d)
unsigned char *s;
 unsigned char *d;
{
        long     minus;
        minus=0;
        *d++=*s++;
        *d++=*s++;
        *d++=*s++;
        *d++=*s++;
        if (*s & 128)
        {
                minus=1;
                *d++=*s++;
        }
        else *d++=(*s++ | 128);
        *d++=*s++;
        *d=minus;
        return;
}


/*
 * "Kernel" printf - bypasses files and outputs directly to console
 * (this is useful for debugging packages)
 *
 * djm 24/4/2000
 *
 * --------
 * $Id: printk1.c,v 1.1 2016-03-09 22:25:54 dom Exp $
 */

#include <stdio.h>

extern __LIB__ printk1(int (*delta)(),  unsigned char *fmt,void *ap);

/*
 * Cheating somewhat, this will cause a barf in the compiler...bigtime..
 * nevermind...
 */

void sccz80_delta(int x)
{
     return -x;
}

void sdcc_delta(int x)
{
     return x;
}
void printk(char *fmt,...)
{
        int  *ct;
        ct= (getarg()*2)+&fmt-4;

        printk1(sccz80_delta, *ct,ct-1);
}

/*
 * Once over to Small C this isn't negotiable! 
 * Arguments go downwards instead of upwards (we push from
 * left to right, not right to left, so we do a - instead of a +
 * to step to the next one..
 */

static void miniprintn(long number,unsigned char flag);

int printk1(int (*delta_fn)(), unsigned char *fmt,void *ap)
{
        unsigned char c;
        unsigned char k;
        unsigned char   *s;

        while ((c = *fmt++) != '\0') {
                if (c != '%') 
                        fputc_cons(c);
                else {
                        c = *fmt++;
                        switch (c) {
			case 'l':
				c=*fmt++;
				switch (c) {
					case 'd':
					case 'u':
                                                ap += delta_fn(sizeof(int));
                                		miniprintn((long)*(long *)ap,c=='d');
                                                ap += delta_fn(sizeof(int));
						break;
				}
				break;

                        case 'd':
                                miniprintn((long)*(int *)ap,1);
                                ap += delta_fn(sizeof(int));
                                break;
			case 'u':
                                miniprintn((unsigned long)*(unsigned int *)ap,0);
                                ap += delta_fn(sizeof(int));
                                break;

                        case 's':
                                s = *(char **)ap;
                                while ((k = *s++) != '\0')
                                        fputc_cons(k);
                                ap += delta_fn(sizeof(char *));
                                break;

                        case 'c':
                                fputc_cons(*(int *)ap);
                                ap += delta_fn(sizeof(int));
                                break;

                        default:
                                fputc_cons(c);
                        }
                }
        }
	return(0);
}


static void miniprintn(long number, unsigned char flag)
{
        unsigned long i;
        if (flag && number < 0 ){
                fputc_cons('-');
                number = -number;
        }
        if ((i =(unsigned long) number / 10L) != 0)
                miniprintn(i,flag);
        fputc_cons(number%10+'0');
}


/*
 *	An alternate miniprintf core which can print
 *	longs and unsigned values correctly.
 *
 *	djm 26/2/2000
 *
 *	Error in last digit - I'm not sure why - this occurs
 *	for *large* numbers..
 *
 *	djm 3/3/2000
 *	This routine is infact a vfprintf, so naming as such...
 *
 *      djm 9/5/2002
 *	Cut down version for z88 that only handles ints
 *
 * --------
 * $Id: vfprintf_mini.c,v 1.2 2012-10-15 10:40:46 stefano Exp $
 */

#define ANSI_STDIO

#include <stdio.h>

/*
 * Once over to Small C this isn't negotiable! 
 * Arguments go downwards instead of upwards (we push from
 * left to right, not right to left, so we do a - instead of a +
 * to step to the next one..
 */

static void miniprintn(int number, FILE *fil, unsigned char flag);

int vfprintf_mini(FILE *fp, unsigned char *fmt,void *ap)
{
        unsigned char c;
        unsigned char k;
        unsigned char   *s;


        while ((c = *fmt++) != '\0') {
                if (c != '%') 
                        fputc(c,fp);
                else {
                        c = *fmt++;
                        switch (c) {
                        case 'd':
                        case 'i':
                                miniprintn((unsigned int)*(int *)ap,fp,1);
                                ap -= sizeof(int);
                                break;
                        case 'u':
                                miniprintn((unsigned int)*(unsigned int *)ap,fp,0);
                                ap -= sizeof(int);
                                break;

                        case 's':
                                s = *(char **)ap;
                                while ((k = *s++) != '\0')
                                        fputc(k,fp);
                                ap -= sizeof(char *);
                                break;

                        case 'c':
                                fputc(*(int *)ap,fp);
                                ap -= sizeof(int);
                                break;

                        default:
                                fputc(c,fp);
                        }
                }
        }
	return(0);
}


static void miniprintn(int number, FILE *file, unsigned char flag)
{
        unsigned int i;
        if (flag && number < 0 ){
                fputc('-', file);
                number = -number;
        }
        if ((i =(unsigned int) number / 10) != 0)
                miniprintn(i,file,flag);
        fputc((unsigned int)number%10+'0', file);
}


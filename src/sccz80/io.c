/*
 *      Small C+ Compiler
 *
 *      Various compiler file i/o routines
 *
 *      $Id: io.c,v 1.1.1.1 2000-07-04 15:33:31 dom Exp $
 */

#include "ccdefs.h"

#ifdef INBUILT_OPTIMIZER
int opt_outc(char c);
#endif

/*
 * get integer of length len bytes from address addr
 */
int getint(addr, len)
unsigned char *addr ;
int len ;
{
        int i ;

        i = *(addr + --len) ;   /* high order byte sign extended */
        while (len--) i = (i << 8) | ( *(addr+len) & 255 ) ;
        return i ;
}

/*
 * put integer of length len bytes into address addr
 * (low byte first)
 */
void putint(i, addr, len)
char *addr ;
int i, len ;
{
        while (len--) {
                *addr++ = i ;
                i >>= 8 ;
        }
}

/*
 * Test if next input string is legal symbol name
 * if it is, truncate it and copy it to sname
 */
int symname(sname)
char *sname;
{
        int k ;

#ifdef SMALL_C
        {
                char *p ;
                char c ;

                /* this is about as deep as nesting goes, check memory left */
                p = alloc(1) ;
                /* &c is top of stack, p is end of heap */
                if ( (k=&c-p) < minavail )
                        minavail = k ;
                free(p) ;
        }
#endif

        blanks();
        if ( alpha(ch()) == 0 )
                return (*sname=0) ;
        k = 0 ;
        while ( an(ch()) ) {
                sname[k] = gch();
                if ( k < NAMEMAX ) ++k ;
        }
        sname[k] = 0;
        return 1;
}

/* Return next avail internal label number */
int getlabel()
{
        return(++nxtlab);
}

/* Print a queue label/reference */

void queuelabel(label)
int label;
{
       	outstr("i_");
       	outdec(label);
}



/* Print specified number as label */
void printlabel(label)
int label;
{
	if (asxx) {
		outdec(label);
		outstr("$");
	} else {
        	outstr("i_");
        	outdec(label);
	}
}

/* print label with colon and newline */
void postlabel(label)
int label;
{
        prefix();
        printlabel(label) ;
        col();
        nl();
}


/* Test if given character is alpha */
int alpha(char c)
{
        if(c>='a') return (c<='z');
        if(c<='Z') return (c>='A');
        return (c=='_');
}

/* Test if given character is numeric */
int numeric(char c)
{
        if(c<='9') return(c>='0');
        return 0;
}

/* Test if given character is alphanumeric */
int an(char c)
{
        if ( alpha(c) ) return 1 ;
        return numeric(c) ;
}

/* Print a carriage return and a string only to console */
void pl(str)
char *str;
{
        putchar('\n');
        while(*str)putchar(*str++);
}



/* initialise staging buffer */

void setstage( before, start )
char **before, **start ;
{
        if ( (*before=stagenext) == 0 )
                stagenext = stage ;
        *start = stagenext ;
}

/* flush or clear staging buffer */

void clearstage( before, start )
char *before, *start ;
{
        *stagenext = 0 ;
        if ( (stagenext=before) ) return ;
        if ( start ) {
                if ( output != NULL_FD ) {
#ifdef INBUILT_OPTIMIZER
                        if (infunc) AddBuffer(start);
                        else 
#endif
                                if ( fputs(start, output) == EOF )
                                        fabort() ;
                }
                else {
                        puts(start) ;
                }
        }
}

void fabort()
{
        closeout();
        error(E_OUTERR);
}

/* direct output to console */
void toconsole()
{
        saveout = output;
        output = 0;
}

/* direct output back to file */
void tofile()
{
        if(saveout)
                output = saveout;
        saveout = 0;
}


int outbyte(char c)
{
        if(c) {
                if ( output != NULL_FD ) {
                        if (stagenext) {
                                return(outstage(c)) ;
                        }
                        else {
#ifdef INBUILT_OPTIMIZER
                                if (infunc) opt_outc(c);
                                else 
#endif
                                        if((putc(c,output))==EOF)
                                                fabort() ;
                        }
                }
                else putchar(c);
        }
        return c;
}

/* output character to staging buffer */

int outstage(char c)
{
        if (stagenext == stagelast) {
                error(E_STGOV) ;
                return 0 ;
        }
        *stagenext++ = c ;
        return c ;
}

void outstr(ptr)
char ptr[];
{
        while(outbyte(*ptr++));
}

void nl()
{
        outbyte('\n');
}

void tab()
{
        outbyte('\t');
}

void col()
{
	if (asxx) 
  	      outbyte(58);    
}

void bell()
{
        outbyte(7);
}



void ol(ptr)
char *ptr ;
{
        ot(ptr);
        nl();
}

void ot(ptr)
char *ptr ;
{
        tab();
        outstr(ptr);
}

void blanks()
{
        while(1) {
                while(ch()==0) {
                        preprocess();
                        if(eof) break;
                }
                if(ch()==' ')gch();
                else if(ch()==9)gch();
                else return;
        }
}


void outdec(number)
int number;
{
        if ( number < 0 ) {
		number=-number;
	/*	number= (int)( 65536UL-(long)number); */
                outbyte('-');
        }
        outd2(number);
}

void outd2(n)
int n ;
{
        if ( n > 9 ) {
                outd2(n/10) ;
                n %= 10 ;
        }
        outbyte('0'+n) ;
}

/* convert lower case to upper */
char raise(char c)
{
        if ( c >= 'a' ) {
                if ( c <= 'z' )
                        c -= 32; /* 'a'-'A'=32 */
        }
        return c ;
}

#ifdef INBUILT_OPTIMIZER
#	include "opt.c"
#endif

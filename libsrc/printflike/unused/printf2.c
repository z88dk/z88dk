/*
 *  printf2.c - generic _printf for floating point output
 *	            also, floating point conversion functions
 *
 *	Compile with -m option
 *
 *	R M Yorston 1987
 *
 */


#include <stdio.h>
#include <float.h>

#define NULL 0
#define ERR -1

extern __LIB__ utoi();
extern __LIB__ itod();
extern __LIB__ itox();
extern __LIB__ itou();



printf2(fd, ctl, nxtarg)
FILE *fd;
unsigned char *ctl;
void *nxtarg;
{
	double *pd ;
	int i, width, prec, preclen, len, pf_count=0 ;
	unsigned char c, right, str[128], pad;
	unsigned char *sptr,  *cx ;

	while ( c = *ctl++ ) {
		if (c != '%' ) {
			fputc(c, fd) ;
			++pf_count;
			continue ;
		}
		if ( *ctl == '%' ) {
			fputc(*ctl++, fd) ;
			++pf_count;
			continue ;
		}
		cx = ctl ;
		if ( *cx == '-' ) {
			right = 0 ;
			++cx ;
		}
		else
			right = 1 ;
		if ( *cx == '0' ) {
			pad = '0' ;
			++cx ;
		}
		else
			pad = ' ' ;
		if ( (i=utoi(cx, &width)) >= 0 )
			cx += i ;
		else
			continue  ;
		if (*cx == '.') {
			if ( (preclen=utoi(++cx, &prec)) >= 0 )
				cx += preclen ;
			else
				continue ;
		}
		else
			preclen = 0 ;
		sptr = str ;
		c = *cx++ ;
		i = *(--nxtarg) ;
		switch(c) {
			case 'd' :
				itod(i, str, 7) ;
				break ;
			case 'x' :
				itox(i, str, 7) ;
				break ;
			case 'c' :
				str[0] = i ;
				str[1] = NULL ;
				break ;
			case 's' :
				sptr = i ;
				break ;
			case 'u' :
				itou(i, str, 7) ;
				break ;
			default:
				if ( preclen == 0 )
					prec = 6 ;
				if ( c == 'f' ) {
					nxtarg -= 2 ;
					pd = nxtarg ;
					ftoa( *pd, prec, str ) ;
				}
				else if ( c == 'e' ) {
					nxtarg -= 2 ;
					pd = nxtarg ;
					ftoe( *pd, prec, str ) ;
				}
				else
					continue ;
		}
		ctl = cx ; /* accept conversion spec */
		if ( c != 's' )
			while ( *sptr == ' ' )
				++sptr ;
		len = -1 ;
		while ( sptr[++len] )
			; /* get length */
		if ( c == 's' && len>prec && preclen>0 )
			len = prec ;
		if (right)
			while ( ((width--)-len) > 0 ) {
				fputc(pad, fd) ;
				++pf_count;
			}
		while ( len ) {
			fputc(*sptr++, fd) ;
			++pf_count;
			--len ;
			--width ;
		}
		while ( ((width--)-len) > 0 ) {
			fputc(pad, fd) ;
			++pf_count;
		}
	}
	return(pf_count) ;
}


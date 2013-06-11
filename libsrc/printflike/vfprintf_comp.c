/*
 *      printf1 - generic _printf routine for integer-only operation
 *
 *
 *      R M Yorston 1987
 */


#include <stdio.h>


extern __LIB__ utoi(); 

int vfprintf_comp(FILE *fd, unsigned char *ctl,void *ap)
{
	int i, prec, preclen, len ;
	unsigned char c, right, str[25], pad;
	int width, pf_count=0;
	unsigned char *sptr, *cx ;

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
		i = *ap;
		ap -= sizeof(int);

		switch(c) {
		case 'l':
			c = *cx++;
			if ((c == 'd') || (c == 'i') || (c == 'u') || (c == 'x')) {
				ltoa_any(*(long *)ap,str,20,( c == 'x' ? 16 : 10 ),((c == 'd')||(c == 'i')));
				ap -= sizeof(int);
			} else
			    continue ;
			break;
		case 'u' :
			ltoa_any((unsigned long)i,str,7,10,0);
			break ;
		case 'd' :
		case 'i' :
			ltoa_any(i,str,7,10,1);
			break ;
		case 'x' :
			ltoa_any((unsigned long)i,str,7,16,0);
			break ;
		case 'c' :
			str[0] = i ;
			str[1] = 0 ;
			break ;
		case 's' :
			sptr = (unsigned char *)i ;
			if (sptr == 0) sptr = "(null)";
			break ;

		default:
		continue ;
		}
		
		ctl = cx ; /* accept conversion spec */
		if ( c != 's' && c != 'c' )
			while ( *sptr == ' ' )
				++sptr ;
		len = -1 ;
		while ( sptr[++len] )
				; /* get length */
		if ( c == 's' && len>prec && preclen>0 )
			len = prec ;
		if (right)
		#asm
		;rep1
		#endasm
			while ( ((width--)-len) > 0 ) {
				fputc(pad, fd) ;
				++pf_count;
			}
		#asm
		;rep1-end
		#endasm
		while ( len ) {
			fputc(*sptr++, fd) ;
			++pf_count;
			--len ;
			--width ;
		}
		#asm
		;rep2
		#endasm
		while ( ((width--)-len) > 0 ) {
			fputc(pad, fd) ;
			++pf_count;
		}
		#asm
		;rep2-end
		#endasm
	}
	return(pf_count) ;
}

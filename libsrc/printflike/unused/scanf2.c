/*
 * Core routine for scanf-type functions, including floating point
 *        only e, f, d, o, x, c, s, and u specs are supported.
 *        Also includes atof()
 */


#include <ctype.h>
#include <stdio.h>
#include <float.h>

#define ERR (-1)


extern __LIB__ utoi() ;


int scanf2(fd, ctl, nxtarg)
FILE *fd;
unsigned char *ctl;
void *nxtarg ;
{
	unsigned char *carg, *zunsigned, fstr[40] ;
	int *narg, wast, ac, width,   base, ovfl  ;
	unsigned char cnv,sign,ch;
	double *farg ;

	ac = 0 ;
	while ( *ctl) {
		if ( isspace(*ctl) ) { ++ctl; continue; }
		if ( *ctl++ != '%' ) continue ;
		if ( *ctl == '*' ) { farg = narg = carg = &wast; ++ctl; }
		else                 farg = narg = carg = *nxtarg-- ;
		ctl += utoi(ctl, &width) ;
		if ( !width ) width = 32767 ;
		if ( !(cnv=*ctl++) ) break ;
		while ( isspace(ch=fgetc(fd)) )
			;
		if ( ch == EOF ) {
			if (ac) break ;
			else return EOF ;
		}
		ungetc(ch,fd) ;
		switch(cnv) {
			case 'c' :
				*carg = fgetc(fd) ;
				break ;
			case 's' :
				while ( width-- ) {
					if ( (*carg=fgetc(fd)) == EOF ) break ;
					if ( isspace(*carg) ) break ;
					if ( carg != &wast ) ++carg ;
				}
				*carg = 0 ;
				break ;
			case 'e' :
			case 'f' :
				if ( width > 39 ) width = 39 ;
				_getf(fstr, fd, width) ;
				*farg = atof(fstr) ;
				break ;
			default :
				switch(cnv) {
					case 'd' : base = 10 ; sign = 0 ; ovfl = 3276 ; break ;
					case 'o' : base =  8 ; sign = 1 ; ovfl = 8191 ; break ;
					case 'u' : base = 10 ; sign = 1 ; ovfl = 6553 ; break ;
					case 'x' : base = 16 ; sign = 1 ; ovfl = 4095 ; break ;
					default : return ac ;
				}
				*narg = zunsigned = 0 ;
				while ( width-- && !isspace(ch=fgetc(fd)) && ch!=EOF ) {
					if ( !sign )
						if ( ch == '-' ) { sign = -1; continue; }
						else sign = 1 ;
					if ( ch < '0' ) return ac ;
					if ( ch >= 'a') ch -= 87 ;
					else if ( ch >= 'A' ) ch -= 55 ;
					else ch -= '0' ;
					if ( ch >= base || zunsigned > ovfl ) return ac ;
					zunsigned = zunsigned * base + ch ;
				}
				*narg = sign * zunsigned ;
		}
		++ac ;
	}
	return ac ;
}


/*
 * _getf - fetch string representation of floating point number
 *         from file (or string).  Maximum number of characters
 *         examined is width.
 */
_getf(s, fd, width)
unsigned char *s ;			/* result string */
FILE *fd ;			/* file descriptor */
int width ;			/* number of characters to be examined */
{
	int i ;

	i = 1 ;
	*s = fgetc(fd) ;
	if ( isdigit(*s) || *s == '-' || *s == '.' ) {
		if ( *s != '.' ) {
			/* fetch figures before point */
			while ( isdigit(*++s=fgetc(fd)) ) {
				if ( ++i > width ) {
					ungetc(*s,fd) ;
					*s = NULL ;
					return ;
				}
			}
		}
		if ( *s == '.' ) {
			/* fetch figures after point */
			while ( isdigit(*++s=fgetc(fd)) ) {
				if ( ++i > width ) {
					ungetc(*s,fd) ;
					*s = NULL ;
					return ;
				}
			}
		}
		/* check for exponent */
		if ( tolower(*s) == 'e' ) {
			*++s = fgetc(fd) ;
			if ( ++i > width ) {
				ungetc(*s,fd) ;
				*s = NULL ;
				return ;
			}
			if ( isdigit(*s) || *s == '-' ) {
				/* fetch figures of exponent */
				while ( isdigit(*++s=fgetc(fd)) ) {
					if ( ++i > width ) {
						ungetc(*s,fd) ;
						*s = NULL ;
						return ;
					}
				}
			}
		}
	}
	ungetc(*s,fd) ;
	*s = NULL ;
}

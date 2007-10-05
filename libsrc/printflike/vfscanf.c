/*
 * Core routine for integer-only scanf-type functions
 *        only d, o, x, c, s, and u specs are supported.
 */


#include <ctype.h>
#include <stdio.h>

#define ERR (-1)

extern __LIB__ utoi() ;


int vfscanf(fd, ctl, nxtarg)
    FILE *fd;
    unsigned char *ctl;
    void *nxtarg ;
{
    unsigned char *carg;
    unsigned int zunsigned ;
    int *narg, wast, ac, width, ovfl ;
    int  sign;
    unsigned char ch, base, cnv;

    ac = 0 ;
    while ( *ctl) {
        if ( isspace(*ctl) ) { ++ctl; continue; }
        if ( *ctl++ != '%' ) continue ;
        if ( *ctl == '*' ) { narg = carg = &wast; ++ctl; }
        else  {
			narg = carg = *nxtarg;
			nxtarg -= sizeof(int) ;
		}
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

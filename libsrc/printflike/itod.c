
/*
 * itod -- convert nbr to signed decimal string of width sz
 *             right adjusted, blank filled ; returns str
 *
 *            if sz > 0 terminate with null byte
 *            if sz  =  0 find end of string
 *            if sz < 0 use last byte for data
 */

/* Black magic */

#include <stdio.h>


int itod(int nbr, char str[], int sz);


itod(nbr, str, sz)
int nbr ;
char str[] ;
int sz ;
{
        char sgn ;

        if ( nbr < 0 ) {
                nbr = -nbr ;
                sgn = '-' ;
        }
        else
                sgn = ' ' ;
        if ( sz > 0 )
                str[--sz] = NULL ;
        else if ( sz < 0 )
                        sz = -sz ;
                else
                        while ( str[sz] != NULL )
                                ++sz ;
        while ( sz ) {
                str[--sz] = nbr % 10 + '0' ;
                if ( (nbr/=10) == 0 )
                        break ;
        }
        if ( sz )
                str[--sz] = sgn ;
        while ( sz > 0 )
                str[--sz] = ' ' ;
        return str ;
}

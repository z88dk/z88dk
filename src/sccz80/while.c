/*
 *      Small C+ Compiler
 *
 *      Couple of routines for while statements
 *
 *      $Id: while.c,v 1.1.1.1 2000-07-04 15:33:32 dom Exp $
 */

#include "ccdefs.h"



void addwhile(ptr)
WHILE_TAB *ptr ;
{
        wqptr->sp = ptr->sp = Zsp ;                             /* record stk ptr */
        wqptr->loop = ptr->loop = getlabel() ;  /* and looping label */
        wqptr->exit = ptr->exit = getlabel() ;  /* and exit label */
        if ( wqptr >= WQMAX ) {
                error(E_WHILE);
                return;
        }
        ++wqptr ;
}

void delwhile()
{
        if ( wqptr > wqueue ) --wqptr ;
}

#ifndef SMALL_C
WHILE_TAB *
#endif

readwhile(ptr)
WHILE_TAB *ptr ;
{
        if ( ptr <= wqueue ) {
                error(E_CONTEXT);
                return 0;
        }
        else return (ptr-1) ;
}

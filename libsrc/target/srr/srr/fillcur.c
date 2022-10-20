/*=======================================================
 
        if (mode==0)
          fills from the beginning of the screen to
          the cursor.
        else
          fills from the cursor to the end of the screen.
 
        The string pointed to by s is used as many times
        as required to fill.
 
        Returns the cursor address.
*/
 
#include <sorcerer.h>

fillcur(int mode, char *s)
 
{
        int csr,*pbase,*psize,pend;
        csr=cursor(-1,-1);
        pbase=getplot();
        psize=pbase+3;
        pend =*pbase+*psize-1;
        if (mode==0)
           srr_fill(*pbase,csr,s,0);
        else
           srr_fill(csr,pend,s,0);
        return csr;     /* return the cursor position */
}


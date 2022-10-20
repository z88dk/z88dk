/*=======================================================
 
        If (mode==0)
          fills the plot area from the beginning of the
          current line to the cursor address.
        else
          fills the plot area from the cursor address to
          the end of the current line.
 
        The string pointed to by s is used as many times
        as needed to fill the area.
 
        Returns the cursor address.
*/
 
#include <sorcerer.h>

int linefill(int mode, char *s)
 
{       int csr,k,l,*pbase,*ysize,*xsize;
 
        csr=cursor(-1,-1);
        pbase=getplot();
        ysize=pbase+1;
        xsize=ysize+1;
        l=*pbase;
        for (k=0;k<*xsize;k++)
        {
          if (l>csr) break;
          l+=*ysize;
        }
 
 
        if (mode==0)
        {
          k=l-*ysize;
          srr_fill(k,csr,s,0);
        }
        else
        {
          k=l-1;
          srr_fill(csr,k,s,0);
        }
        return csr;     /* return the cursor position */
}


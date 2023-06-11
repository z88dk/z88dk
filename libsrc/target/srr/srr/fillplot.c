/*=======================================================
 
        Fills the plot area from the string pointed to
        by s. The string is reused until the plot area
        is full.
        The address of the (0,0) position of the screen
        is returned.
*/

#include <sorcerer.h>

int *fillplot(char *s)
 
{
        int *pbase,*psize;
 
        pbase=getplot();
        psize=pbase+3;        /* pointers are NOT integers! */ 
        srr_fill(*pbase,*psize,s,1);
        return *pbase;        /* return the screen RAM addr */
}

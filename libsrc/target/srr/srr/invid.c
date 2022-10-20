 
/*=======================================================
 
        This routine creates a standard inverse video
        character set for the Exidy Sorcerer.
        The inverse character generator resides in both
        the standard and user graphics areas (ie from
        0xfc00 through to 0xffff).
*/

#include <sorcerer.h>

void invid()
{
        int *p1,*p2;
 
        for (p1=0xf800,p2=0xfc00;p2;*p2++=~(*p1++));
}
 

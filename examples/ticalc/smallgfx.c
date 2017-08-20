/* Draw a series of concentric circles
 */


#pragma string name Concentric Circles
#pragma output nostreams

#include <graphics.h>

main()
{
int i;
for (i=50 ; i>0; i=i-7)
 {
 circle(50,44,i,1);
 if (i < 15 ) i=i-1;
 }
}


#include <graphics.h>

main()
{
        int	i;

/* Draw a series of concentric circles 
 */
 	
        for (i=50 ; i>0; i=i-7)
        {
                circle(50,44,i,1);
                if (i < 15 ) i=i-1;
        }
        
	while (1!=2) {}
}


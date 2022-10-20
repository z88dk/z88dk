/*=======================================================
 
        Reads standard Exidy tape as in 'rtape' but then
        chains to the execution address on the tape header.
        NO return values (of course!)
*/


#include <stdlib.h>
#include <string.h>
#include <sorcerer.h>
 
void rtapeg(char *name, int unit, int addr)
 
{       char monbuf[50];
/* 
        sprintf(monbuf,"LOG %s %x %x",name,unit,addr);
        return monitor(monbuf);
*/

	char parm[6];

	strcpy(monbuf, "LOG ");
	strcat(monbuf, name);
	strcat(monbuf, " 1 ");

	itoa(addr,parm,16);
	strcat(monbuf, parm);

	monitor(monbuf);
	
}

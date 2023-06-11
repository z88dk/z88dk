/*=======================================================
 
        Reads Standard Exidy tape file of name 'name'
        from tape 'unit' into address 'addr'.
        Returns 0 for bad, 1 for ok.
*/


#include <stdlib.h>
#include <string.h>
#include <sorcerer.h>

int rtape(char *name, int unit, int addr)
 
{       char monbuf[50];
/* 
        sprintf(monbuf,"LO %s %x %x",name,unit,addr);
        return monitor(monbuf);
*/

	char parm[6];

	strcpy(monbuf, "LO ");
	strcat(monbuf, name);
	strcat(monbuf, " 1 ");

	itoa(addr,parm,16);
	strcat(monbuf, parm);

	return monitor(monbuf);
	
}


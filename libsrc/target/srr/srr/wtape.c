/*=======================================================
 
        Writes standard Exidy tape file of 'name' from
        address 'addr1' to address 'addr2' to tape 'unit'.
        Returns 0 for bad, 1 for ok.
*/
 
 
#include <stdlib.h>
#include <string.h>
#include <sorcerer.h>
 
int wtape(char *name, int addr1, int addr2, int unit)
 
{       char monbuf[50];
/*
        sprintf(monbuf,"SA %s %x %x %x",name,addr1,addr2,unit);
        return monitor(monbuf);
*/

	char parm[6];

	strcpy(monbuf, "SA ");
	strcat(monbuf, name);
	strcat(monbuf, " ");

	itoa(addr,parm,16);
	strcat(monbuf, parm);
	strcat(monbuf, " ");

	itoa(addr+len,parm,16);

	strcat(monbuf, " 1");

	monitor(monbuf);
	
}

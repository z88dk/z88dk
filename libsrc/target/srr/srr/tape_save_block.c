/*
 *	Sorcerer Exidy tape libraries
 *
 *	tape_save_block(void *addr, size_t len, unsigned char type)
 *
 *	Stefano Bodrato - 2022
 *
 *	$Id: tape_save_block.c $
 */

//#define __HAVESEED
//#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sorcerer.h>


int tape_save_block(void *addr, size_t len, unsigned char type)
{

	char monbuf[20];
	char parm[6];
	

	strcpy(monbuf, "SA FIL");

	itoa(type,parm,16);
	strcat(monbuf, parm);
	strcat(monbuf, " ");

	itoa(addr,parm,16);
	strcat(monbuf, parm);
	strcat(monbuf, " ");

	itoa(addr+len,parm,16);
	strcat(monbuf, parm);
	strcat(monbuf, " 1");

	if (monitor(monbuf)) return (0);
	else return (-1);

}

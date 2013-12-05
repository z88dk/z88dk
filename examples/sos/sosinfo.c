/*
 *	S-OS demo program
 * By Stefano Bodrato, 2013
 * 
 * $Id: sosinfo.c,v 1.1 2013-12-05 09:36:03 stefano Exp $
 */


#include <stdio.h>
#include <sos.h>
//#include <debug.h>

unsigned int x;

main()
{
	printf("-- S-OS Information --\n");
	x=get_sos_model();
	printf("V.$%x ",x);
	switch (x) {
		case 0x00:
			printf(" (Sharp MZ-80K/C/1200)");
			break;
		case 0x01:
			printf(" (Sharp MZ-700)");
			break;
		case 0x02:
			printf(" (Sharp MZ-1500)");
			break;
		case 0x10:
			printf(" (Sharp MZ-2000/2200)");
			break;
		case 0x11:
			printf(" (Sharp MZ-2000/2200)");
			break;
		case 0x12:
			printf(" (Sharp MZ-2500)");
			break;
		case 0x16:
			printf(" (UNIX emulator)");
			break;
		case 0x20:
			printf(" (Sharp X1)");
			break;
		case 0x21:
			printf(" (X1 Turbo - Oh! MZ)");
			break;
		case 0x21:
			printf(" (X1 Turbo - High-Speed)");
			break;
		case 0x30:
			printf(" (NEC PC-8801 - ROM)");
			break;
		case 0x30:
			printf(" (NEC PC-8001)");
			break;
		case 0x32:
			printf(" (NEC PC-8801 - RAM)");
			break;
		case 0x40:
			printf(" (Fujitsu FM-7/77)");
			break;
		case 0x50:
			printf(" (Sony SMC-777)");
			break;
		case 0x60:
			printf(" (Toshiba Pasopia)");
			break;
		case 0x61:
			printf(" (Toshiba Pasopia 7)");
			break;
		case 0x70:
			printf(" (PC-286 emulator)");
			break;
		case 0x80:
			printf(" (X68000 emulator)");
			break;
		case 0x90:
			printf(" (MSX2 ANK version)");
			break;
		case 0x91:
			printf(" (MSX2 Kanji version)");
			break;
		case 0xff:
			printf(" (Sharp PC-G850)");
			break;
	};
	printf("\n");

	printf("S-OS level: $%x",get_sos_version());
	if (get_sos_version() > 0x1F) printf (" (disk supported)");
		else printf(" (tape access only)");
	printf("\n");
	
	printf("Default Stack position: $%x\n",SOS_STKAD);
	printf("Hot boot entry: $%x\n",SOS_HOT);
	printf("Cold boot entry: $%x\n",SOS_COLD);
	if ((SOS_MEMAX!=0)&&(SOS_MEMAX!=65535))
		printf("User area size: %uK\n",(SOS_MEMAX-0x3000)/1024);
	else {
		printf("Can't determine the user area size\n");
		x=0xfffe;
		
		if ((SOS_COLD>0x3000)&&(SOS_COLD<x))
			x=SOS_COLD;
		if ((SOS_HOT>0x3000)&&(SOS_HOT<x))
			x=SOS_HOT;
		if ((SOS_STKAD>0x3000)&&(SOS_STKAD<x))
			x=SOS_STKAD;
		if ((SOS_KBFAD>0x3000)&&(SOS_KBFAD<x))
			x=SOS_KBFAD;
		if ((SOS_IBFAD>0x3000)&&(SOS_IBFAD<x))
			x=SOS_IBFAD;

		if (x!=0xfffe)
			printf("    Guessing.. <=%uK?\n",(x-0x3000)/1024);
			else
			printf("    Guessing.. <=%uK?\n",(0xfff0-0x3000)/1024);
		}
	if ((SOS_WKSIZ!=0)&&(SOS_WKSIZ!=0xffff))
		printf("Work area size: %u\n",SOS_WKSIZ);
	else
		printf("Can't determine the work area size\n");
	printf("Screen size: %ux%u\n",SOS_WIDTH,SOS_MXLIN);
	printf("Current device: '%c:'\n",SOS_DSK);
	
}


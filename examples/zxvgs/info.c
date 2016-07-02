
#include <zxvgs.h>
#include <stdio.h>

#define APP_NAME="INFO"

int video()
{
#pragma asm
	LD	DE,$FF00
	LD	HL,$0000
	LD	BC,$0000
	RST	8
	DEFB	$A7
	LD	L,D
	LD	H,0
#pragma endasm
}

main()
{
 int ok1, ok2;
 printf("ZXVGS Info 0.30\n");
 printf("(C) 2003-03-07 Jarek Adamski\n\n");
 printf("Hardware type: ");
 switch(video())
  {case 0x00: printf("Sinclair ZX Spectrum (+) ULA 6C001E-7"); break;
   case 0x01: printf("Sinclair ZX+ 128 AMSTRAD 40056"); break;
   case 0x02: printf("Amstrad ZX +2 ULA 7K010E5"); break;
   case 0x03: printf("Amstrad ZX +2A/+2B/+3 GATE ARRAY 40077"); break;
   case 0x0C: printf("MGT SAM Coupé ASIC"); break;
   case 0x20: printf("Timex Sinclair 2068 TS 2068 - 60Hz"); break;
   case 0x21: printf("Timex Computer 2068 TS 2068 - 50Hz, grey"); break;
   case 0x22: printf("Timex Computer 2048 TS 2068 - 50Hz, black"); break;
   case 0x80: printf("ELWRO 800 Junior"); break;
   case 0x81: printf("Solum"); break;
   case 0xC0: printf("Pentagon"); break;
   case 0xC1: printf("ZS Scorpion"); break;
   case 0xF0: printf("Warajevo emulator"); break;
   default: printf("unknown");
  }
 printf("\nAvailable memory: %dkB\n",16*(3+bnkfree()));
 printf("AY-3-891X sound: ");
 ok1=(opensound(1,077)==077); //device 1 is AY in ZX128
 opensound(1,0);
 ok2=(opensound(2,077)==077); //device 2 is AY in TC2068
 opensound(2,0);
 if (!(ok1 || ok2)) printf("not ");
 printf("available ");
 if (ok1) printf("in ZX128 mode ");
 if (ok1 && ok2) printf ("or ");
 if (ok2) printf("in TC2068 mode");
 printf("\nSAA 1099 sound: ");
 ok1=(opensound(4,077)==077); //device 4 is SAA1099 in Sam
 opensound(4,0);
 if (!ok1) printf("not ");
 printf("available\n");
}

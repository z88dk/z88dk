
/* DCT/CCC - display Drive Code Table data */

/*
  Converted to z88dk by Stefano Bodrato from a MISOSYS C example
  Original code was commented out rather than removed
   
  To build:
      zcc +trs80 -create-app -subtype=disk -O3 -DAMALLOC dct.c
      zcc +trs80 -create-app -subtype=disk -DAMALLOC -compiler=sdcc --max-allocs-per-node200000 dct.c

  ** LDOS is required, change the GTDCT address if you have a Model 4 **
	
  If the file output redirection is not needed, 
  add "-lndos" to reduce the program size
  
*/


#include <stdio.h>
//#include <z80regs.h>
//#option	INLIB

#define	GTDCT			0x478f	// Model I, III
// #define	GTDCT			81  // Model 4

#define	MAXDRIVES		8
#define	JP				0xC3
#define	RET				0xC9
#define	enabled(dct)	(dct->dct_instr == JP)

typedef unsigned char uchar;

struct dct
{	uchar dct_instr;				/* JP or RET instr */
	char *dct_driver_addr;			/* driver address */

	/* DCT byte 4 flags: */

	unsigned dct_inhibit: 1;		/* 7:	inhibit @CKDRV */
	unsigned dct_ddc	: 1;		/* 6:	1=double den controller */
	unsigned dct_2sid	: 1;		/* 5:	floppy:1=2-sided drive */
	#define  dct_dbl	dct_2sid	/* 5:	hard:double cyl count */
	unsigned dct_al		: 1;		/* 4:	1=alien disk controller */
	unsigned dct_faddr	: 4;		/* 3-0:	floppy drive addr (1,2,4,8) */

	/* DCT byte 3 flags: */

	unsigned dct_wp		: 1;		/* 7:	1=software write protect */
	unsigned dct_dden	: 1;		/* 6:	1=DDEN / 0=SDEN oper */
	unsigned dct_8in	: 1;		/* 5:	1=8" / 0=5.25" drive */
	unsigned dct_side	: 1;		/* 4:	side select 1/0 */
	unsigned dct_hard	: 1;		/* 3:	1=hard / 0=floppy */
	unsigned dct_dly	: 1;		/* 2:	1=0.5 / 0=1.0 sec delay */
	#define  dct_fixd	dct_dly		/* 2:	hard:1=fixed/0=removable */
	unsigned dct_step	: 2;		/* 1-0:	FDC step rate (0,1,2,3) */
	#define  dct_haddr	dct_step	/* 1-0: hard drive address */

	uchar dct_curr;					/* current cylinder pos */
	uchar dct_high;					/* highest cylinder */

	/* DCT byte 8 allocation data: */

	unsigned dct_gpc	: 3;		/* 7-5:	granules per cyl (0-7) */
	unsigned dct_spg	: 5;		/* 4-0:	sectors per gran (0-31) */

	/* DCT byte 7 allocation data: */

	unsigned dct_head	: 3;		/* 7-5:	hard: # of heads (0-7) */
	unsigned dct_spc	: 5;		/* 4-0:	sectors per cyl (0-31) */

	uchar dct_dir;					/* directory cylinder */
} *dct;

int i, dblbit;

//printf(", %s ms step", step[dct->dct_8in][dct->dct_step]);

//union REGS regs;


//char *step[2][4] = { "6", "12", "20", "30", "3", "6", "10", "15" };
//char *delay[2][2] = { "1.0", "0.5", "1.0", "0.0" };

char *step[2][4] = { {"6", "12", "20", "30"}, {"3", "6", "10", "15"} };
char *delay[2][2] = { {"1.0", "0.5"}, {"1.0", "0.0"} };


int get_dct(int i)
{
// SCCZ80 accepts both #asm and __asm, we use the latter to be compatible to SDCC
__asm
	pop hl
	pop bc		; regs.C = i;
	push bc
	push hl
	call GTDCT	; call(GTDCT, &regs);
	push iy
	pop hl		; regs.IY
__endasm;
}




main()
{	for (i = 0; i < MAXDRIVES; ++i)
	{	//regs.C = i;
		//call(GTDCT, &regs);
		//dct = (struct dct *) regs.IY;
		dct = (struct dct *)get_dct(i);	//  <-- replaces the original "call"
		printf("Drive %d ", i);
		if (enabled(dct))
		{	printf("enabled:\n");
			printf("\t%srite-protected\n", dct->dct_wp ? "W" : "Not w");
			printf("\t%s #", dct->dct_hard ? "Rigid" : "Floppy");
			printf("%d", dct->dct_hard ? dct->dct_haddr : dct->dct_faddr);
			printf(", %s\"", dct->dct_8in ? "8" : "5");
			if (dct->dct_hard)
				printf(", %d head(s)", dct->dct_head + 1);
			else
			{	printf(", %sD", dct->dct_dden ? "D" : "S");
				printf(", %sS", dct->dct_2sid ? "D" : "S");
				printf(", %s sec delay", delay[dct->dct_8in][dct->dct_dly]);
				printf(", %s ms step", step[dct->dct_8in][dct->dct_step]);
			}
			printf("\n");
			printf("\t@CKDRV %sinhibited\n", dct->dct_inhibit ? "" : "not ");
			dblbit = dct->dct_hard ? dct->dct_dbl : 0;
			printf("\tCylinders %u, directory cylinder %u\n",
				(dct->dct_high + 1) << dblbit, dct->dct_dir << dblbit);
			if (! dct->dct_hard)
				dblbit = dct->dct_2sid;
			printf("\tSectors per cylinder %d\n",
				(dct->dct_spc + 1) << dblbit);
			printf("\tGranules per cylinder %d\n",
				(dct->dct_gpc + 1) << dblbit);
			printf("\tSectors per granule %d\n", dct->dct_spg + 1);
		}
		else
			printf("disabled\n");
		printf("\n");
	}
}

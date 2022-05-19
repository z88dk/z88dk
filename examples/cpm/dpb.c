/*
 *	Analyse the CP/M Disk Parameter Block and print its values
 *  It will probably work on CP/M v2 only
 */


#include <stdio.h>
#include <stdlib.h>
#include <cpm.h>

struct dpb *dp;
int xltab;



unsigned int get_xlt(int drive)
{
#asm
	ld c,l		; (fastcall parm)
	
	ld hl,(1)   ; base+1 = addr of jump table + 3
    ld l,27     ; point to seldisk

	ld e,0      ; If bit 0 of E is 0, then the disc is logged in as if new

	push hl     ; save bios entry
	ld  hl,retxlt
	ex  (sp),hl
	jp  (hl)     ; jp into bios entry

retxlt:
	; How HL points to the Disk Parameter Header (zero=error)
	ld	a,h
	or	l
	ret	z

	ld	a,(hl)
	inc hl
	ld	h,(hl)
	ld  l,a
#endasm
}



main()
{
	printf("Parameters for current drive (%c:)\n\n",'A'+get_current_volume());
	if ( (dp = get_dpb(get_current_volume())) == NULL)
	{
		printf("Select error\n\n");
		exit(0);
	}

	printf("Sectors per Track (SPT)..%u\n",dp->SPT);
	printf("Block Shift (BSH)........%u\n",dp->BSH);
	printf("Block Mask (BLM).........%u\n",dp->BLM);
	printf("Extent Mask (EXM)........%u\n",dp->EXM);
	printf("Total Blocks (DSM).......%u\n",dp->DSM);
	printf("Directory Entries (DRM)..%u\n",dp->DRM);
	printf("Allocation 0 (AL0).......%2Xh\n",dp->AL0);
	printf("Allocation 1 (AL1).......%2Xh\n",dp->AL1);
	printf("Dir chk vector sz (CKS)..%u\n",dp->CKS);
	printf("Cylinder Offset (OFF)....%u\n",dp->OFF);

	if ( (xltab = get_xlt(get_current_volume())) == NULL)
	{
		printf("No software interleave\n\n");
		exit(0);
	}


}


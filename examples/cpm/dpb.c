/*
 *  Analyse the CP/M Disk Parameter Block and print its values
 *  It will probably work on CP/M v2 only
 *
 *  Compile with sccz80
 *  zcc +cpm dpb.c -o dpb.bin -create-app
 *
 *  Compile with sdcc
 *  zcc +cpm -compiler=sdcc -O3 dpb.c -o dpb.bin -create-app
 *
 *  By Stefano Bodrato, May 2022
 *
 */


#include <stdio.h>
#include <stdlib.h>
#include <cpm.h>

struct dpb * dp;
int blk_size, mask_count;
int sec_count, cpm_ver;
unsigned char * xltab;


unsigned char * get_xlt(int drive) __z88dk_fastcall
{
	(void) drive;	/* avoid warnings */

__asm
	ld c,l		; (fastcall parm)

	ld hl,(1)	; base+1 = addr of jump table + 3
	ld l,27		; point to seldisk

	ld e,0		; If bit 0 of E is 0, then the disc is logged in as if new

	push hl		; save bios entry
	ld hl,retxlt
	ex (sp),hl
	jp (hl)		; jp into bios entry

retxlt:
			; How HL points to the Disk Parameter Header (zero=error)
	ld a,h
	or l
	ret z

	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
__endasm;

}


main()
{
	cpm_ver = bdos(CPM_VERS,0);

	if ((cpm_ver == 0) || (cpm_ver > 0x2F))
		printf("\nWARNING: unsupported CP/M version detected: %x.%x\n\n", cpm_ver >> 4, cpm_ver & 0xf);

	printf("Parameters for current drive (%c:)\n\n",'A'+get_current_volume());
	if ((dp = get_dpb(get_current_volume())) == NULL)
	{
		printf("Select error\n\n");
		exit(0);
	}

	printf("Sectors per Track (SPT)..%u",dp->SPT);
	if (dp->SPT == 26)
		printf(" 8\"\n");
	else
		printf("\n");

	printf("Block Shift (BSH)........%u\n",dp->BSH);
	printf("Block Mask (BLM).........%u\n",dp->BLM);
	printf("Extent Mask (EXM)........%u\n",dp->EXM);
	printf("Total Blocks (DSM).......%u\n",dp->DSM);
	printf("Directory Entries (DRM)..%u\n",dp->DRM);
	printf("Allocation 0 (AL0).......%2Xh\n",dp->AL0);
	printf("Allocation 1 (AL1).......%2Xh\n",dp->AL1);
	printf("Dir chk vector sz (CKS)..%u\n",dp->CKS);
	printf("Cylinder Offset (OFF)....%u\n",dp->OFF);

	printf("\n-- Press 'Y' for more --\n",dp->OFF);

	while ((getk() != 'y') && (getk() != 'Y')) {};

	printf("\nDetected CP/M version: %x.%x\n", cpm_ver >> 4, cpm_ver & 0xf);

	if ((xltab = get_xlt(get_current_volume())) == NULL)
	{
		printf("No software interleave\n\n");
	} else {
		printf("Skew %u.\nInterleave table: ", xltab[1]-xltab[0]);
		for (sec_count = 0; sec_count < dp->SPT; sec_count++)
			printf("%u ",xltab[sec_count]);
		printf("\n\n");
	}

	if (dp->DSM < 256)
		blk_size=1024;
	else
		blk_size=2048;

	for (mask_count = dp->EXM+1; mask_count /= 2; mask_count>=0) {
		blk_size *= 2;
	}

	if (blk_size != 128<<(dp->BSH))
		printf("(warning: block size could also be %u).\n",128<<(dp->BSH));

	//printf("Formatted capacity: %lu, block (extent) size: %u.\n", (long)blk_size*((long)dp->DSM+1),blk_size);
	printf("Block (extent) size: %u.\n", blk_size);
	printf("MAX directory entries: %u, %u per block (%u blocks used).\n", dp->DRM+1, blk_size/32, (dp->DRM+1)/(blk_size/32));
	return 0;
}


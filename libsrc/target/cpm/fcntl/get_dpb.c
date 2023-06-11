/*
 *  Point to the Disk Parameter Block of the given drive number
 *
 *  May, 2022 - Stefano
 *
 *  $ Id: get_dpb $
 */


#include <cpm.h>


struct dpb *get_dpb(int drive)
{
#asm
	ld c,l		; (fastcall parm)
	
	ld hl,(1)   ; base+1 = addr of jump table + 3
    ld l,27     ; point to seldisk

	ld e,0      ; If bit 0 of E is 0, then the disc is logged in as if new

	push hl     ; save bios entry
	ld  hl,retadd
	ex  (sp),hl
	jp  (hl)     ; jp into bios entry

retadd:
	; How HL points to the Disk Parameter Header (zero=error)
	ld	a,h
	or	l
	ret	z

	ld de,10	; DPB offset
	add hl,de
	ld	a,(hl)
	inc hl
	ld	h,(hl)
	ld  l,a
#endasm
}


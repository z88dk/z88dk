/*
 *	Call a CPM BIOS routine
 *
 *	$Id: bios.c$
 */

#include <cpm.h>


#asm

	EXTERN	__cpm_base_address
	EXTERN	__bdos

cpm_bios:

	ld	hl,4
	add	hl,sp

	push hl
	ld c,12		; S_BDOSVER
	call __bdos
	cp 30h		; check for CP/M version below 3.0
	pop hl

IF !__CPU_INTEL__
	push	ix
ENDIF
	ld	e,(hl)	;arg2
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)	;arg
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	a,(hl)  ; get function number (1-85)
	jr	c,use_vector	; CY set = CP/M version below 3.0

	ld (BIOSPB),a	; FUNCTION
	ld (BIOSPB+2),bc
	ld (BIOSPB+4),de

	ld de,BIOSPB
	ld c,50  	; 32h (S_BIOS)
	call __bdos
IF !__CPU_INTEL__
	pop	ix
ENDIF
	ret


BIOSPB:
	defb 0	; FUNC
	defb 0	; A reg		; not assigned
	defw 0  ; BC reg
	defw 0  ; DE reg
	defw 0  ; HL reg	; not assigned


; if CP/M version is < 2.5, we spot the BIOS JP table
; using the WBOOT entry (at position $0000, points to BIOS+3)
use_vector:
	ld hl,(__cpm_base_address+1)   ; base+1 = addr of jump table + 3

	dec hl	; -3
	dec hl
	dec hl
	
	push de
	ld  e,a     ; multiply by 3
	add a,a
	add a,e
	
	ld  e,a
	ld  d,0
	add hl,de   ; add to base of jump table
	pop de
	
	push hl     ; save the computed entry

	ld  hl,retadd
	ex  (sp),hl ; ready
	jp  (hl)

retadd:
IF !__CPU_INTEL__
	pop	ix
ENDIF
    ret

#endasm


int bios(int func,int arg,int arg2)
{
#asm
	call cpm_bios
	ld	l,a     ; all done. now put return value in HL
	ld	h,0
#endasm
}

int biosh(int func,int arg,int arg2)
{
#asm
	call cpm_bios
#endasm
}

;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern void vdp_vwrite(void *source, u_int dest, u_int count)
;
;	Transfer count bytes from RAM to VRAM (BIOS paged version)
;
;	$Id: vdp_vwrite.asm,v 1.9 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	vdp_vwrite
	PUBLIC	_vdp_vwrite
	
	EXTERN     msxbios
	
IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


vdp_vwrite:
_vdp_vwrite:
	push	ix
        ld      ix,4
        add     ix,sp

	ld c, (ix+0)	; count
	ld b, (ix+1)

	ld e, (ix+2)	; dest
	ld d, (ix+3)
	
	ld l, (ix+4)	; source
	ld h, (ix+5)
	
	ld	ix,LDIRVM
	call	msxbios
	pop	ix
	ret
	

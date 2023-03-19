;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	int vdp_color(int foreground, int background, int border );
;
;	Change the MSX color attributes
;
;	$Id: vdp_color.asm $
;

        SECTION code_clib
	PUBLIC	vdp_color
	PUBLIC	_vdp_color
	EXTERN	msxbios
	EXTERN	__tms9918_attribute
	
IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
        INCLUDE "target/msx/def/msxbasic.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
        INCLUDE "target/svi/def/svibasic.def"
ENDIF


vdp_color:
_vdp_color:
	push	ix
	ld	ix,2
	add	ix,sp
	ld	a,(ix+2)	;border
	ld	(BDRCLR),a
	ld	a,(ix+6)	;foreground
	and	$0f
	ld	(FORCLR),a
	rlca
	rlca
	rlca
	rlca
	and	$f0
	ld	l,a
	ld	a,(ix+4)	;background
	and	$0f
	ld	(BAKCLR),a
	or	l
	ld	(__tms9918_attribute),a
	ld	a,(0FCAFh)	;SCRMOD
	ld	ix,CHGCLR
	call	msxbios
	pop	ix
	ret

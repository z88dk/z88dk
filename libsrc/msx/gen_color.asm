;
;	z88dk library: Generic VDP support code
;
;	int msx_color(int foreground, int background, int border );
;
;	Change the color attributes (MSX style)
;
;	$Id: gen_color.asm,v 1.4 2016-07-14 17:44:17 pauloscustodio Exp $
;

        SECTION code_clib
	PUBLIC	msx_color
	PUBLIC	_msx_color

	EXTERN	SETWRT
	EXTERN	set_vdp_reg
	
	;EXTERN	SCRMOD

	INCLUDE	"msx/vdp.inc"

msx_color:
_msx_color:
	push	ix		;save callers
	ld	ix,2
	add	ix,sp
	
	;ld	a,(SCRMOD)	;SCRMOD

	dec     a
	push    af
	ld      a,(ix+6)	;foreground
	rlca
	rlca
	rlca
	rlca
	and     $F0
	ld      l,a
	ld      a,(ix+2)	;border
	or      l

	ld      b,a
	ld      c,7
	call    set_vdp_reg
	pop     af
	pop	ix		;restore callers
	;ret     nz
	ret

	; SCREEN1
;	ld      a,(ix+6)	;foreground
;	rlca
;	rlca
;	rlca
;	rlca
;	and     $F0
;	ld	a,(ix+4)	;background
;	or      (hl)
;	ld      hl,$2000	; VDP table for 32 columns text mode
;	ld      bc,$0020
;	push    af
;	call    SETWRT
;cclr_lp:
;	pop     af
;	out     (VDP_DATA),a
;	push    af
;	dec     bc
;	ld      a,b
;	or      c
;	jr      nz,cclr_lp
;	pop     af
;	ret

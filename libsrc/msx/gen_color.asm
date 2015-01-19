;
;	z88dk library: Generic VDP support code
;
;	int msx_color(int foreground, int background, int border );
;
;	Change the color attributes (MSX style)
;
;	$Id: gen_color.asm,v 1.2 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_color

	EXTERN	SETWRT
	EXTERN	set_vdp_reg
	
	;XREF	SCRMOD

	INCLUDE	"msx/vdp.inc"

msx_color:
	ld	ix,0
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

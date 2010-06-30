;
;	z88dk library: Generic VDP support code
;
;	void set_vdp_reg(int reg, int value)
;
;==============================================================
;	Sets the value of a VDP register
;==============================================================
;
;	$Id: gen_set_vdp_reg.asm,v 1.1 2010-06-30 13:21:38 stefano Exp $
;

	XLIB	set_vdp_reg
	XREF	RG0SAV

	INCLUDE	"msx/vdp.inc"


.set_vdp_reg
	ld	hl, 2
	add	hl, sp
	
	ld	a, (hl)		; Value
	ld	c,a
	inc	hl
	inc	hl
	di
	out	(VDP_CMD),a
	
	ld	a, (hl)		; Register #
	out	(VDP_CMD),a
	ei

	ld	a,c
	cp	8
	ret	nc

.savereg
	ld	hl,RG0SAV
	ld	b,0
	add	hl,bc
	ld	(hl),a

	ret

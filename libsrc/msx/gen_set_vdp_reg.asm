;
;	z88dk library: Generic VDP support code
;
;	void set_vdp_reg(int reg, int value)
;
;==============================================================
;	Sets the value of a VDP register
;==============================================================
;
;	$Id: gen_set_vdp_reg.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	set_vdp_reg
	PUBLIC	_set_vdp_reg
	EXTERN	RG0SAV

	INCLUDE	"msx/vdp.inc"


.set_vdp_reg
._set_vdp_reg
	ld	hl, 2
	add	hl, sp
	
	ld	a, (hl)		; Value
	ld	c,a
	inc	hl
	inc	hl
	di
IF VDP_CMD > 255
	ld	(VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
	
	ld	a, (hl)		; Register #
IF VDP_CMD > 255
	ld	(VDP_CMD),a
ELSE
	out	(VDP_CMD),a
ENDIF
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

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
	EXTERN	l_tms9918_disable_interrupts
	EXTERN	l_tms9918_enable_interrupts

	INCLUDE	"video/tms9918/vdp.inc"


.set_vdp_reg
._set_vdp_reg
	ld	hl, 2
	add	hl, sp
	ld	d, (hl)		; Value
	inc	hl
	inc	hl
	call	l_tms9918_disable_interrupts
IF VDP_CMD < 0
	ld	a,d
	ld	(-VDP_CMD),a
ELSE
	ld	bc,VDP_CMD
	out	(c),d
ENDIF
	
	ld	e, (hl)		; Register #
IF VDP_CMD < 0
	ld	a,e
	ld	(-VDP_CMD),a
ELSE
	out	(c),e
ENDIF
	call	l_tms9918_enable_interrupts
        ld      a,e
	cp	8
	ret	nc		;REgister out of boundds

.savereg
	ld	hl,RG0SAV
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	(hl),d	; Value

	ret

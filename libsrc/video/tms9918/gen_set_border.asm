; void msx_set_border(int c) __z88dk_fastcall


	SECTION		code_clib
	PUBLIC		msx_set_border
	PUBLIC		_msx_set_border

	EXTERN		l_tms9918_disable_interrupts
	EXTERN		l_tms9918_enable_interrupts
	EXTERN		RG0SAV

	INCLUDE		"video/tms9918/vdp.inc"

msx_set_border:
_msx_set_border:
	ld	a,l
	and	15
	ld	l,a
	ld	a,(RG0SAV+7)
	and	@11110000
	or	l
	ld      e,a
	call	l_tms9918_disable_interrupts
	ld	a,e
	ld	(RG0SAV+7),a
IF VDP_CMD < 0
        ld      (-VDP_CMD),a
ELSE
	ld	bc,VDP_CMD
	out	(c),a
ENDIF
	ld	a,$87
IF VDP_CMD < 0
        ld      (-VDP_CMD),a
ELSE
        out     (c),a
ENDIF
	call	l_tms9918_enable_interrupts
	ret


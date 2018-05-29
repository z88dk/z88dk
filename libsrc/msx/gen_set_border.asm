; void msx_set_border(int c) __z88dk_fastcall


	SECTION		code_clib
	PUBLIC		msx_set_border
	PUBLIC		_msx_set_border

	EXTERN		l_push_di
	EXTERN		l_pop_ei
	EXTERN		RG0SAV

	INCLUDE		"msx/vdp.inc"

msx_set_border:
_msx_set_border:
	ld	a,l
	and	15
	ld	l,a
	ld	a,(RG0SAV+7)
	and	@11110000
	or	l
	ld      e,a
	call	l_push_di
	ld	a,e
	ld	(RG0SAV+7),a
IF VDP_CMD > 255
        ld      (VDP_CMD),a
ELSE
        out     (VDP_CMD),a
ENDIF
	ld	a,$87
IF VDP_CMD > 255
        ld      (VDP_CMD),a
ELSE
        out     (VDP_CMD),a
ENDIF
	call	l_pop_ei
	ret


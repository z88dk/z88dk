; void bordercolor(int c) __z88dk_fastcall;
;
;

	SECTION		code_clib
	PUBLIC		__tms9918_bordercolor
	EXTERN		__tms9918_map_colour
	EXTERN		msx_set_border

        INCLUDE "video/tms9918/vdp.inc"

IF VDP_EXPORT_DIRECT = 1
	PUBLIC		bordercolor
	PUBLIC		_bordercolor

	defc	bordercolor = __tms9918_bordercolor
	defc	_bordercolor = __tms9918_bordercolor
ENDIF

__tms9918_bordercolor:
	ld	a,l
	call	__tms9918_map_colour
	ld	l,a
	jp	msx_set_border

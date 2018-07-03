;
;	MSX specific routines
;
;	Improved functions by Rafael de Oliveira Jannone
;	Originally released in 2004 for GFX - a small graphics library
;
;	int msx_vpeek(int address);
;
;	Read the MSX video memory
;
;	$Id: msx_vpeek.asm,v 1.10 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_vpeek
	PUBLIC	_msx_vpeek
	
	INCLUDE	"msx/vdp.inc"


msx_vpeek:
_msx_vpeek:
	; (FASTCALL) -> HL = address

	;ld	ix,RDVRM
	;call	msxbios
	
	; enter vdp address pointer
	ld	a,l
	di
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
ELSE
	ld	bc,VDP_CMD
	out	(c),a
ENDIF
	ld	a,h
	and	@00111111
	ei
IF VDP_CMD < 0
	ld	(-VDP_CMD),a
	out	(c),a
ENDIF

	; read data
IF VDP_DATAIN < 0
	ld	a,(-VDP_DATAIN)
ELSE
	IF VDP_DATAIN > 255
		ld	a,VDP_DATAIN / 256
	ENDIF
	in	a,(VDP_DATAIN % 256)
ENDIF
	
	ld	h,0
	ld	l,a
	ret


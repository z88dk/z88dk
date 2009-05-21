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
;	$Id: msx_vpeek.asm,v 1.6 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	msx_vpeek
	
	
IF FORmsx
        INCLUDE "#msx.def"
ELSE
        INCLUDE "#svi.def"
ENDIF


msx_vpeek:
	; (FASTCALL) -> HL = address

	;ld	ix,RDVRM
	;call	msxbios
	
	; enter vdp address pointer
	ld	a,l
	di
	out	(VDP_CMD), a
	ld	a,h
	and	@00111111
	ei
	out	(VDP_CMD), a

	; read data
	in	a,(VDP_DATAIN)
	
	ld	h,0
	ld	l,a
	ret


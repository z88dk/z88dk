;
;       Clear Graphics Screen
;
;       MSX version by Stefano Bodrato, December 2007
;
;	$Id: clg.asm,v 1.2 2009-01-21 16:00:08 stefano Exp $
;

        XLIB    clg
        LIB	msxbios
        LIB	msx_color

        INCLUDE "#msxbios.def"
        INCLUDE	"graphics/grafix.inc"
       
.clg

	ld	ix,CHGMOD
	ld	a,2		; set graphics mode
	call	msxbios

	ld	a,15
	ld	(0F3EBh),a	;border
	ld	a,2
	ld	ix,CHGCLR
	call	msxbios
	
	ld bc,6144

	ld a,$1F

	ld hl,8192

	ld ix,FILVRM
	jp msxbios


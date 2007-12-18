;
;       Clear Graphics Screen
;
;       MSX version by Stefano Bodrato, December 2007
;
;	$Id: clg.asm,v 1.1 2007-12-18 09:00:35 stefano Exp $
;

        XLIB    clg
        LIB	msxbios

        INCLUDE "#msxbios.def"
        INCLUDE	"graphics/grafix.inc"
       
.clg
	ld	ix,CHGMOD
	ld	a,2		; set graphics mode
	call	msxbios

	ld	ix,CLS
	jp	msxbios

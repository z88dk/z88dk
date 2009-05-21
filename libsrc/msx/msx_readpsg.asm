;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_readpsg(int regno);
;
;	Read the specified PSG register
;
;
;	$Id: msx_readpsg.asm,v 1.2 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	msx_readpsg

	;;LIB     msxbios
	
IF FORmsx
        INCLUDE "#msx.def"
ELSE
        INCLUDE "#svi.def"
ENDIF


msx_readpsg:
	ld	a,l
	;ld	ix,RDPSG
	;call	msxbios
	
	out	(PSG_ADDR),a
	in	a,(PSG_DATAIN)	
	
	ld	h,0
	ld	l,a	; NOTE: A register has to keep the same value
	ret		;       internal code is using it !

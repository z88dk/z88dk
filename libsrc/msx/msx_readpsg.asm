;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_readpsg(int regno);
;
;	Read the specified PSG register
;
;
;	$Id: msx_readpsg.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;

	XLIB	msx_readpsg

	;;LIB     msxbios
	
IF FORmsx
        INCLUDE "msx.def"
ELSE
        INCLUDE "svi.def"
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

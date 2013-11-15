;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_readpsg(int regno);
;
;	Read the specified PSG register
;
;
;	$Id: get_psg.asm,v 1.1 2013-11-15 10:59:30 stefano Exp $
;

	XLIB	get_psg	

	;;LIB     msxbios
	
IF FORmsx
        INCLUDE "msx.def"
ELSE
        INCLUDE "svi.def"
ENDIF


get_psg:
	ld	a,l
	;ld	ix,RDPSG
	;call	msxbios
	
	out	(PSG_ADDR),a
	in	a,(PSG_DATAIN)	
	
	ld	h,0
	ld	l,a	; NOTE: A register has to keep the same value
	ret		;       internal code is using it !

;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_initpsg();
;
;	Init the PSG (reset sound etc..)
;
;
;	$Id: psg_init.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	psg_init
	EXTERN     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

psg_init:
	ld	ix,GICINI
	jp	msxbios

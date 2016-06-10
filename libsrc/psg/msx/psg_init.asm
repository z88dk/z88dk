;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_initpsg();
;
;	Init the PSG (reset sound etc..)
;
;
;	$Id: psg_init.asm,v 1.3 2016-06-10 21:13:58 dom Exp $
;

        SECTION code_clib
	PUBLIC	psg_init
	PUBLIC	_psg_init
	EXTERN     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

psg_init:
_psg_init:
	ld	ix,GICINI
	jp	msxbios

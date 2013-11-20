;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_sound(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm,v 1.2 2013-11-20 15:44:01 stefano Exp $
;

	XLIB	set_psg_callee
	LIB     msxbios

	XDEF ASMDISP_SET_PSG_CALLEE

	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry

	ld	a,l
	
	ld	ix, WRTPSG
	jp	msxbios

DEFC ASMDISP_SET_PSG_CALLEE = asmentry - set_psg_callee

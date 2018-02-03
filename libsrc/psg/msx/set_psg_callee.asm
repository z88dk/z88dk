;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_sound(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm,v 1.5 2016-06-10 21:13:58 dom Exp $
;

        SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee
	EXTERN     msxbios

	PUBLIC ASMDISP_SET_PSG_CALLEE

	
IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF

set_psg_callee:
_set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry

	ld	a,l
	push	ix	
	ld	ix, WRTPSG
	call	msxbios
	pop	ix
	ret

DEFC ASMDISP_SET_PSG_CALLEE = # asmentry - set_psg_callee

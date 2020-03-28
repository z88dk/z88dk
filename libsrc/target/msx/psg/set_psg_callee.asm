;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_sound(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm $
;

        SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee
;;	EXTERN     msxbios

	PUBLIC ASMDISP_SET_PSG_CALLEE

	
IF FORmsx
        INCLUDE "target/msx/def/msx.def"
ELSE
        INCLUDE "target/svi/def/svi.def"
ENDIF

set_psg_callee:
_set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry

	ld	a,l

	di
	out     (PSG_ADDR),a
	push    af
	ld      a,e
	out     (PSG_DATA),a
	ei
	pop     af

	ret

DEFC ASMDISP_SET_PSG_CALLEE = asmentry - set_psg_callee

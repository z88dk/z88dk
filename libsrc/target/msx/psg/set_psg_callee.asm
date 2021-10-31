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

	PUBLIC asm_set_psg

	
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
	
.asm_set_psg

	ld	a,l
        cp      7
        jr      nz,not_reg7
        ld      a,e
        and     @00111111
        or      @10000000
        ld      e,a
        ld      a,l
not_reg7:
	di
	out     (PSG_ADDR),a
	push    af
	ld      a,e
	out     (PSG_DATA),a
	ei
	pop     af

	ret


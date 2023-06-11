        SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee

	PUBLIC asm_set_psg

        INCLUDE "target/bic/bic.def"

	
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
        cpl
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


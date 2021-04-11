;
;

        SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee

	PUBLIC asm_set_psg

	
set_psg_callee:
_set_psg_callee:

;        ld      a,register
;        ld      e,data
;        call    $1BC5


   pop hl
   pop de
   ex (sp),hl
	
asm_set_psg:
	ld	a,l
	out	($c1),a
	ld	a,e
	out	($c0),a
	ret



;
;

        SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee

	PUBLIC ASMDISP_SET_PSG_CALLEE
        EXTERN PSG_AY_REG
        EXTERN PSG_AY_DATA

	
set_psg_callee:
_set_psg_callee:

;        ld      a,register
;        ld      e,data
;        call    $1BC5


   pop hl
   pop de
   ex (sp),hl
	
asmentry:
	ld	a,l
	out	(PSG_AY_REG),a
	ld	a,e
	out	(PSG_AY_DATA),a
	ret

DEFC ASMDISP_SET_PSG_CALLEE = asmentry - set_psg_callee


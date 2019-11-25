; void wpoke_callee(void *addr, uint word)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC wpoke_callee
PUBLIC _wpoke_callee
PUBLIC ASMDISP_WPOKE_CALLEE

.wpoke_callee
._wpoke_callee
IF __CPU_GBZ80__
   pop bc	;ret
   pop de	;word
   pop hl	;addr
   push bc
ELSE
   pop hl
   pop de
   ex (sp),hl
ENDIF

.asmentry

   ld (hl),e
   inc hl
   ld (hl),d
   ret

DEFC ASMDISP_WPOKE_CALLEE = asmentry - wpoke_callee

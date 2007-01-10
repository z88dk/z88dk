; void wpoke_callee(void *addr, uint word)
; 11.2006 aralbrec

XLIB wpoke_callee
XDEF ASMDISP_WPOKE_CALLEE

.wpoke_callee

   pop af
   pop de
   pop hl
   push af

.asmentry

   ld (hl),e
   inc hl
   ld (hl),d
   ret

DEFC ASMDISP_WPOKE_CALLEE = asmentry - wpoke_callee

; void __CALLEE__ bpoke_callee(void *addr, uchar byte)
; 11.2006 aralbrec

XLIB bpoke_callee
XDEF ASMDISP_BPOKE_CALLEE

.bpoke_callee

   pop af
   pop de
   pop hl
   push af
   
.asmentry

   ld (hl),e
   ret

DEFC ASMDISP_BPOKE_CALLEE = asmentry - bpoke_callee

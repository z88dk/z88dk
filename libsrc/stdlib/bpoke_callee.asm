; void __CALLEE__ bpoke_callee(void *addr, uchar byte)
; 11.2006 aralbrec

PUBLIC bpoke_callee
PUBLIC ASMDISP_BPOKE_CALLEE

.bpoke_callee

   pop hl
   pop de
   ex (sp),hl
   
.asmentry

   ld (hl),e
   ret

DEFC ASMDISP_BPOKE_CALLEE = # asmentry - bpoke_callee

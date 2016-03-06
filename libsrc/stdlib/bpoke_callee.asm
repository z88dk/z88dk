; void __CALLEE__ bpoke_callee(void *addr, uchar byte)
; 11.2006 aralbrec

SECTION code_clib
PUBLIC bpoke_callee
PUBLIC _bpoke_callee
PUBLIC ASMDISP_BPOKE_CALLEE

.bpoke_callee
._bpoke_callee

   pop hl
   pop de
   ex (sp),hl
   
.asmentry

   ld (hl),e
   ret

DEFC ASMDISP_BPOKE_CALLEE = # asmentry - bpoke_callee

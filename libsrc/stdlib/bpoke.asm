; void bpoke(void *addr, uchar byte)
; 11.2006 aralbrec

XLIB bpoke
XDEF ASMDISP_BPOKE

.bpoke

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

.asmentry

   ld (hl),e
   ret

DEFC ASMDISP_BPOKE = asmentry - bpoke

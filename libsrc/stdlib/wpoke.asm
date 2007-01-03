; void wpoke(void *addr, uint word)
; 11.2006 aralbrec

XLIB wpoke
XDEF ASMDISP_WPOKE

.wpoke

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

.asmentry

   ld (hl),e
   inc hl
   ld (hl),d
   ret

DEFC ASMDISP_WPOKE = asmentry - wpoke

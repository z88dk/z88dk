; void div(div_t *d, int num, int denom)
; 12.2006 aralbrec

XLIB div
LIB l_div
XDEF ASMDISP_DIV

.div

   pop af
   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   push af
   
   ; bc = div_t *
   ; de = num
   ; hl = denom
   
.asmentry

   push bc
   call l_div                ; hl = q, de = r
   ex de,hl
   ex (sp),hl

   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   pop de
   ld (hl),e
   inc hl
   ld (hl),d
   
   ret

DEFC ASMDISP_DIV = asmentry - div

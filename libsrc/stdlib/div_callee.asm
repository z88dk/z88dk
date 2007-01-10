; void __CALLEE__ div_callee(div_t *d, int num, int denom)
; 12.2006 aralbrec

XLIB div_callee
XDEF ASMDISP_DIV_CALLEE
LIB l_div

.div_callee

   pop af
   pop hl
   pop de
   pop bc
   push af

   ; enter : bc = div_t *d
   ;         de = int num
   ;         hl = int denom

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

DEFC ASMDISP_DIV_CALLEE = asmentry - div_callee

; void __CALLEE__ im2_RegHookLast_callee(uchar vector, void *hook)
; 04.2004 aralbrec

SECTION code_clib
PUBLIC im2_RegHookLast_callee
PUBLIC _im2_RegHookLast_callee
PUBLIC ASMDISP_IM2_REGHOOKLAST_CALLEE
EXTERN _im2_hookDisp

.im2_RegHookLast_callee
._im2_RegHookLast_callee

   pop hl
   pop de
   ex (sp),hl

.asmentry

; enter: de = address of hook (subroutine)
;         l = interrupt vector where Generic ISR is installed
; used : af, bc, hl

.IM2RegHookLast

   ld a,i
   ld h,a
   ld c,(hl)
   inc hl
   ld b,(hl)
   ld hl,_im2_hookDisp - 1
   add hl,bc            ; hl points at hooks list-1

.loop

   inc hl
   ld a,(hl)
   inc hl
   or (hl)
   jp nz, loop

   ld (hl),d            ; found empty slot
   dec hl
   ld (hl),e
   ret

DEFC ASMDISP_IM2_REGHOOKLAST_CALLEE = # asmentry - im2_RegHookLast_callee

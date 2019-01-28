; void __CALLEE__ im2_RegHookFirst_callee(uchar vector, void *hook)
; 04.2004 aralbrec

SECTION code_clib
PUBLIC im2_RegHookFirst_callee
PUBLIC _im2_RegHookFirst_callee
PUBLIC ASMDISP_IM2_REGHOOKFIRST_CALLEE
EXTERN _im2_hookDisp

.im2_RegHookFirst_callee
._im2_RegHookFirst_callee

   pop hl
   pop de
   ex (sp),hl

.asmentry

; enter: de = address of hook (subroutine)
;         l = interrupt vector where generic ISR is installed
; used : af, bc, de, hl

.IM2RegHookFirst

   ld a,i
   ld h,a
   ld c,(hl)
   inc hl
   ld b,(hl)
   ld hl,_im2_hookDisp - 1
   add hl,bc            ; hl points at hooks list-1

.loop

   inc hl
   ld c,(hl)
   ld (hl),e
   inc hl
   ld a,(hl)            ; ac = old first hook
   ld (hl),d            ; insert new first hook
   ld d,a
   or c
   ret z                ; if old==NULL, done insertion
   ld e,c               ; de = old hook = new hook to insert
   jp loop

DEFC ASMDISP_IM2_REGHOOKFIRST_CALLEE = # asmentry - im2_RegHookFirst_callee

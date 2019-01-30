; void __CALLEE__ *im2_InstallISR_callee(uchar vector, void *isr)
; 04.2004 aralbrec

SECTION code_clib
PUBLIC im2_InstallISR_callee
PUBLIC _im2_InstallISR_callee
PUBLIC ASMDISP_IM2_INSTALLISR_CALLEE

.im2_InstallISR_callee
._im2_InstallISR_callee

   pop hl
   pop de
   ex (sp),hl

.asmentry

; enter:  l = vector to install on (even by convention)
;        de = new ISR address
; exit : hl = old ISR address
; uses : af, de, hl

.IM2InstallISR

   ld a,i
   ld h,a
   ld a,(hl)
   ld (hl),e
   ld e,a
   inc hl
   ld a,(hl)
   ld (hl),d
   ld d,a
   ex de,hl
   ret

DEFC ASMDISP_IM2_INSTALLISR_CALLEE = # asmentry - im2_InstallISR_callee

; int __CALLEE__ im2_RemoveHook_callee(uchar vector, void *hook)
; 04.2004 aralbrec

SECTION code_clib
PUBLIC im2_RemoveHook_callee
PUBLIC _im2_RemoveHook_callee
PUBLIC ASMDISP_IM2_REMOVEHOOK_CALLEE
EXTERN IM2RemoveHook

.im2_RemoveHook_callee
._im2_RemoveHook_callee

   pop hl
   pop de
   ex (sp),hl

.asmentry

   call IM2RemoveHook
   ld hl,0
   ret nc
   inc l
   ret

DEFC ASMDISP_IM2_REMOVEHOOK_CALLEE = # asmentry - im2_RemoveHook_callee

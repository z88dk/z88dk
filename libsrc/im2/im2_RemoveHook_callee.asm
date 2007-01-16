; int __CALLEE__ im2_RemoveHook_callee(uchar vector, void *hook)
; 04.2004 aralbrec

XLIB im2_RemoveHook_callee
XDEF ASMDISP_IM2_REMOVEHOOK_CALLEE
LIB IM2RemoveHook

.im2_RemoveHook_callee

   pop bc
   pop de
   pop hl
   push bc

.asmentry

   call IM2RemoveHook
   ld hl,0
   ret nc
   inc l
   ret

DEFC ASMDISP_IM2_REMOVEHOOK_CALLEE = asmentry - im2_RemoveHook_callee

; CALLER linkage for function pointers
; 06.2008 aralbrec

PUBLIC ioctl

EXTERN ioctl_callee
EXTERN ASMDISP_IOCTL_CALLEE

.ioctl

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp ioctl_callee + ASMDISP_IOCTL_CALLEE

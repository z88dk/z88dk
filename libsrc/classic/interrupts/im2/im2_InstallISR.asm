; CALLER linkage for function pointers

SECTION code_clib
PUBLIC im2_InstallISR
PUBLIC _im2_InstallISR

EXTERN asm_im2_InstallISR

.im2_InstallISR
._im2_InstallISR

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp asm_im2_InstallISR

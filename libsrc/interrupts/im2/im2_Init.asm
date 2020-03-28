; void __FASTCALL__ im2_Init_callee(void *tableaddr)
; 04.2004, 02.2008 aralbrec

SECTION code_clib
PUBLIC im2_Init
PUBLIC _im2_Init

.im2_Init
._im2_Init

; enter : hl = address of im2 vector table

   ld a,h
   ld i,a
   im 2
   ret

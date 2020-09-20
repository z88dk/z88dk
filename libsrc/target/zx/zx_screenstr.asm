; uint zx_screenstr(uchar row, uchar col)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_screenstr
PUBLIC _zx_screenstr

EXTERN asm_zx_screenstr

.zx_screenstr
._zx_screenstr

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   ld h,e
   jp asm_zx_screenstr


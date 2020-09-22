; uint zx_attr(uchar row, uchar col)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_attr
PUBLIC _zx_attr

EXTERN asm_zx_attr

.zx_attr
._zx_attr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   ld h,l
   ld l,e
   jp asm_zx_attr

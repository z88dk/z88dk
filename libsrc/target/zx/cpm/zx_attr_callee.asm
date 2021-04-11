; uint __CALLEE__ zx_attr_callee(uchar row, uchar col)
; aralbrec 06.2007

SECTION code_clib
PUBLIC zx_attr_callee
PUBLIC _zx_attr_callee
PUBLIC asm_zx_attr

EXTERN asm_zx_cxy2aaddr

EXTERN p3_peek

.zx_attr_callee
._zx_attr_callee

   pop hl
   pop de
   ex (sp),hl
   ld h,l
   ld l,e
   
.asm_zx_attr

   ; h = char Y 0..23
   ; l = char X 0..31
   
   call asm_zx_cxy2aaddr
   call p3_peek
   ld l,a
   ld h,0
   
   ret


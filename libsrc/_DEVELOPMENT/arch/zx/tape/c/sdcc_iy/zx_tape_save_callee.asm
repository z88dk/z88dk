; unsigned char zx_tape_save(void *src, unsigned int len, unsigned char type)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_tape_save_callee

EXTERN asm_zx_tape_save

_zx_tape_save_callee:

   pop hl
   pop bc
   pop de
   dec sp
   ex (sp),hl
   
   ld a,h
   
l_zx_tape_save_callee:

   push bc
   ex (sp),iy
   
   call asm_zx_tape_save
   
   pop iy
   ret

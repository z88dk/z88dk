; uchar esxdos_f_readdir(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_readdir_callee
PUBLIC l0_esxdos_f_readdir_callee

EXTERN asm_esxdos_f_readdir

_esxdos_f_readdir_callee:

   pop hl
   dec sp
   pop af
   ex (sp),hl

l0_esxdos_f_readdir_callee:

   push iy
   
   call asm_esxdos_f_readdir
   
   pop iy
   ret

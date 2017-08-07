; ulong esxdos_f_seek(uchar handle, ulong dist, uchar whence)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_ram_f_seek_callee
PUBLIC l0_esxdos_ram_f_seek_callee

EXTERN asm_esxdos_f_seek

_esxdos_ram_f_seek_callee:

   pop hl
   dec sp
   pop af
   pop de
   pop bc
   dec sp
   ex (sp),hl

l0_esxdos_ram_f_seek_callee:

   ld l,h
   
   push hl
   ex (sp),ix
   push iy
   
   call asm_esxdos_f_seek
   
   pop iy
   pop ix
   ret

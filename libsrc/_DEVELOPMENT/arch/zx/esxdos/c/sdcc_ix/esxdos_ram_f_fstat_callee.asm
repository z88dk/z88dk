; int esxdos_f_fstat(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_ram_f_fstat_callee
PUBLIC l0_esxdos_ram_f_fstat_callee

EXTERN asm_esxdos_f_fstat

_esxdos_ram_f_fstat_callee:

   pop hl
   dec sp
   pop af
   ex (sp),hl

l0_esxdos_ram_f_fstat_callee:

   push hl
   ex (sp),ix
   push iy
   
   call asm_esxdos_f_fstat
   
   pop iy
   pop ix
   ret

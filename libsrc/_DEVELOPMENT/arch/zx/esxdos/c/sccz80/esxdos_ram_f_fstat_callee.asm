; int esxdos_f_fstat(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_ram_f_fstat_callee

EXTERN asm_esxdos_f_fstat

esxdos_ram_f_fstat_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   ld a,l
   jp asm_esxdos_f_fstat

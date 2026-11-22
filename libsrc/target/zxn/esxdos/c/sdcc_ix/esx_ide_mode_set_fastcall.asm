; unsigned char esx_ide_mode_set(struct esx_mode *mode)

SECTION code_esxdos

PUBLIC _esx_ide_mode_set_fastcall

EXTERN asm_esx_ide_mode_set

_esx_ide_mode_set_fastcall:

   push ix
   push iy
   
   call asm_esx_ide_mode_set
   
   pop iy
   pop ix
   
   ret

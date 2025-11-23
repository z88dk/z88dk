; unsigned char esx_ide_mode_get(struct esx_mode *mode)

SECTION code_esxdos

PUBLIC _esx_ide_mode_get_fastcall

EXTERN asm_esx_ide_mode_get

_esx_ide_mode_get_fastcall:

   push iy
   
   call asm_esx_ide_mode_get
   
   pop iy
   ret

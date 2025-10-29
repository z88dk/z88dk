; unsigned char esx_ide_mode_set(struct esx_mode *mode)

SECTION code_esxdos

PUBLIC _esx_ide_mode_set

EXTERN _esx_ide_mode_set_fastcall

_esx_ide_mode_set:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_ide_mode_set_fastcall

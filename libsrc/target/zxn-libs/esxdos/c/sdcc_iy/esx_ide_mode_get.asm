; unsigned char esx_ide_mode_get(struct esx_mode *mode)

SECTION code_esxdos

PUBLIC _esx_ide_mode_get

EXTERN _esx_ide_mode_get_fastcall

_esx_ide_mode_get:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_ide_mode_get_fastcall

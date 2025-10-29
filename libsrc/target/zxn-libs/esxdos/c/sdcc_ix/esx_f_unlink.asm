; unsigned char esx_f_unlink(unsigned char *filename)

SECTION code_esxdos

PUBLIC _esx_f_unlink

EXTERN _esx_f_unlink_fastcall

_esx_f_unlink:

   pop af
   pop hl
   
   push hl
   push af

   jp _esx_f_unlink_fastcall

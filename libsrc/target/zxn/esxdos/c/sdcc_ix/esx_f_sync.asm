; unsigned char esx_f_sync(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_sync

EXTERN asm_esx_f_sync

_esx_f_sync:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_f_sync

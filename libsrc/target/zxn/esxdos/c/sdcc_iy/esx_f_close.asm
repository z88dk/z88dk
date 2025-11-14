; unsigned char esx_f_close(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_close

EXTERN asm_esx_f_close

_esx_f_close:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_esx_f_close

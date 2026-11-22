; uint32_t esx_f_telldir(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_telldir

EXTERN asm_esx_f_telldir

_esx_f_telldir:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_f_telldir

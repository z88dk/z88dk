; unsigned char esx_f_open(unsigned char *filename,unsigned char mode)

SECTION code_esxdos

PUBLIC _esx_f_open

EXTERN asm_esx_f_open

_esx_f_open:

   pop de
   pop hl
   dec sp
   pop af
   
   push af
   inc sp
   push hl
   push de
   
   jp asm_esx_f_open

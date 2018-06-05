; unsigned char esx_f_readdir(unsigned char handle,struct esx_dirent *dirent)

SECTION code_esxdos

PUBLIC _esx_f_readdir

EXTERN asm_esx_f_readdir

_esx_f_readdir:

   pop de
   dec sp
   pop af
   pop hl
   
   push hl
   push af
   inc sp
   push de

   jp asm_esx_f_readdir

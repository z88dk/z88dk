; unsigned char esx_f_opendir_ex(unsigned char *dirname,uint8_t mode)

SECTION code_esxdos

PUBLIC _esx_f_opendir_ex

EXTERN l0_esx_f_opendir_ex_callee

_esx_f_opendir_ex:

   pop af
   pop hl
   dec sp
   pop bc
   
   push bc
   inc sp
   push hl
   push af
   
   jp l0_esx_f_opendir_ex_callee

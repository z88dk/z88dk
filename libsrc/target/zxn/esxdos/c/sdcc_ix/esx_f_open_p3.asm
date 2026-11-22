; unsigned char esx_f_open_p3(unsigned char *filename,unsigned char mode,struct esx_p3_hdr *h)

SECTION code_esxdos

PUBLIC _esx_f_open_p3

EXTERN l0_esx_f_open_p3_callee

_esx_f_open_p3:

   pop bc
   pop hl
   dec sp
   pop af
   pop de

   push de
   push af
   inc sp
   push hl
   push bc
   
   jp l0_esx_f_open_p3_callee

; unsigned char esx_f_getcwd_drive(unsigned char drive, char *buf)

SECTION code_esxdos

PUBLIC _esx_f_getcwd_drive

EXTERN l_esx_f_getcwd_drive_callee

_esx_f_getcwd_drive:

   pop de
   dec sp
   pop af
   pop hl
   
   push hl
   push af
   inc sp
   push de
   
   jp l_esx_f_getcwd_drive_callee

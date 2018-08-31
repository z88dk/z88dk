; unsigned char esx_f_getcwd_drive(unsigned char drive, char *buf)

SECTION code_esxdos

PUBLIC _esx_f_getcwd_drive_callee
PUBLIC l_esx_f_getcwd_drive_callee

EXTERN asm_esx_f_getcwd_drive

_esx_f_getcwd_drive_callee:

   pop hl
   dec sp
   pop af
   ex (sp),hl

l_esx_f_getcwd_drive_callee:

   push ix
   push iy
   
   call asm_esx_f_getcwd_drive
   
   pop iy
   pop ix

   ret

; unsigned char esx_f_getcwd_drive(unsigned char drive, char *buf)

SECTION code_esxdos

PUBLIC esx_f_getcwd_drive_callee

EXTERN asm_esx_f_getcwd_drive

esx_f_getcwd_drive_callee:

   pop af
   pop hl
   pop de
   push af
   
   ld a,e
   jp asm_esx_f_getcwd_drive

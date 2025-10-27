; unsigned char esx_f_getcwd_drive(unsigned char drive, char *buf)

SECTION code_esxdos

PUBLIC esx_f_getcwd_drive

EXTERN asm_esx_f_getcwd_drive

esx_f_getcwd_drive:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld a,e
   jp asm_esx_f_getcwd_drive

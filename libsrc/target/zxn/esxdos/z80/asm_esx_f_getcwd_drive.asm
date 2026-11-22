; unsigned char esx_f_getcwd_drive(unsigned char drive, char *buf)

SECTION code_esxdos

PUBLIC asm_esx_f_getcwd_drive

EXTERN l_asm_esx_f_getcwd

defc asm_esx_f_getcwd_drive = l_asm_esx_f_getcwd

   ; enter :  a = drive
   ;         hl = buf
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix

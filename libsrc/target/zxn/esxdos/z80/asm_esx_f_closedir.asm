; unsigned char esx_f_closedir(unsigned char handle)

SECTION code_esxdos

PUBLIC asm_esx_f_closedir

EXTERN asm_esx_f_close

defc asm_esx_f_closedir = asm_esx_f_close

   ; enter :  l = handle
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
   ; uses  : af, bc, de, hl

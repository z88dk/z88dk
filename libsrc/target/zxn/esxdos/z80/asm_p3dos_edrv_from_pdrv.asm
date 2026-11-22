; unsigned char p3dos_edrv_from_pdrv(unsigned char pdrv)

SECTION code_esxdos

PUBLIC asm_p3dos_edrv_from_pdrv

EXTERN asm_toupper

asm_p3dos_edrv_from_pdrv:

   ; enter:  l = plus 3 drive 'A'..'P' or 'a'..'p'
   ;
   ; exit :  l = esx drive
   ;
   ; uses : af, l
   
   ld a,l
   call asm_toupper
   
   sub 'A'
   
   add a,a
   add a,a
   add a,a

   inc a
   
   ld l,a
   ret

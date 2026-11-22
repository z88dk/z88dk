; unsigned char p3dos_pdrv_from_edrv(unsigned char edrv)

SECTION code_esxdos

PUBLIC asm_p3dos_pdrv_from_edrv

asm_p3dos_pdrv_from_edrv:

   ; enter:  l = esx drive
   ;
   ; exit :  l = p3 drive 'A'..'P'
   ;
   ; uses : af, l

   ld a,l
   
   rra
   rra
   rra
   
   and $1f
   add a,'A'
   
   ld l,a
   ret

; unsigned char p3dos_pdrv_from_edrv(unsigned char edrv)

SECTION code_esxdos

PUBLIC _p3dos_pdrv_from_edrv

EXTERN asm_p3dos_pdrv_from_edrv

_p3dos_pdrv_from_edrv:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_p3dos_pdrv_from_edrv

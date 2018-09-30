; unsigned char p3dos_edrv_from_pdrv(unsigned char pdrv)

SECTION code_esxdos

PUBLIC _p3dos_edrv_from_pdrv

EXTERN asm_p3dos_edrv_from_pdrv

_p3dos_edrv_from_pdrv:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_p3dos_edrv_from_pdrv

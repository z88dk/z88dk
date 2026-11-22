; unsigned char p3dos_edrv_from_pdrv(unsigned char pdrv)

SECTION code_esxdos

PUBLIC _p3dos_edrv_from_pdrv_fastcall

EXTERN asm_p3dos_edrv_from_pdrv

defc _p3dos_edrv_from_pdrv_fastcall = asm_p3dos_edrv_from_pdrv

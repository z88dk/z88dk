; uchar esxdos_f_opendir_p3(char *path)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_opendir_p3

EXTERN asm_esxdos_f_opendir

esxdos_f_opendir_p3:

   ld a,__ESXDOS_DRIVE_CURRENT
   ld b,__ESXDOS_MODE_USE_HEADER

   jp asm_esxdos_f_opendir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_opendir_p3
defc _esxdos_f_opendir_p3 = esxdos_f_opendir_p3
ENDIF


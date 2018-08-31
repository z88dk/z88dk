; uchar esxdos_f_opendir(char *path)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_opendir

EXTERN asm_esxdos_f_opendir

esxdos_f_opendir:

   ld a,__ESXDOS_DRIVE_CURRENT
   ld b,0

   jp asm_esxdos_f_opendir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_opendir
defc _esxdos_f_opendir = esxdos_f_opendir
ENDIF


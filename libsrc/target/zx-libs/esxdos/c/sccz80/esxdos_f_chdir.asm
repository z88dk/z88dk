; int esxdos_f_chdir(void *path)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_chdir

EXTERN asm_esxdos_f_chdir

esxdos_f_chdir:

   ld a,__ESXDOS_DRIVE_CURRENT
   jp asm_esxdos_f_chdir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_chdir
defc _esxdos_f_chdir = esxdos_f_chdir
ENDIF


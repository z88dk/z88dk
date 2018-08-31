; int esxdos_f_getcwd(void *buf)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_getcwd

EXTERN asm_esxdos_f_getcwd

esxdos_f_getcwd:

   ld a,__ESXDOS_DRIVE_CURRENT
   jp asm_esxdos_f_getcwd

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_getcwd
defc _esxdos_f_getcwd = esxdos_f_getcwd
ENDIF


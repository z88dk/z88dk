; int esxdos_f_sync(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_sync

EXTERN asm_esxdos_f_sync

defc esxdos_f_sync = asm_esxdos_f_sync

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_sync
defc _esxdos_f_sync = esxdos_f_sync
ENDIF


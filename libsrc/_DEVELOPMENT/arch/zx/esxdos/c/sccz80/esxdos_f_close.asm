; int esxdos_f_close(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_close

EXTERN asm_esxdos_f_close

defc esxdos_f_close = asm_esxdos_f_close

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_close
defc _esxdos_f_close = esxdos_f_close
ENDIF


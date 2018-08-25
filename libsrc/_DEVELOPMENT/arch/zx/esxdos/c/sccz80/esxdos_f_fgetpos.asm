; ulong esxdos_f_fgetpos(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_fgetpos

EXTERN asm_esxdos_f_fgetpos

defc esxdos_f_fgetpos = asm_esxdos_f_fgetpos

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_fgetpos
defc _esxdos_f_fgetpos = esxdos_f_fgetpos
ENDIF


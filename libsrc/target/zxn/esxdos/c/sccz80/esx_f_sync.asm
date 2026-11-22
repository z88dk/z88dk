; unsigned char esx_f_sync(unsigned char handle)

SECTION code_esxdos

PUBLIC esx_f_sync

EXTERN asm_esx_f_sync

defc esx_f_sync = asm_esx_f_sync

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_sync
defc _esx_f_sync = esx_f_sync
ENDIF


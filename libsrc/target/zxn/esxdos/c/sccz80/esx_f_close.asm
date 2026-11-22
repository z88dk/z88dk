; unsigned char esx_f_close(unsigned char handle)

SECTION code_esxdos

PUBLIC esx_f_close

EXTERN asm_esx_f_close

defc esx_f_close = asm_esx_f_close

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_close
defc _esx_f_close = esx_f_close
ENDIF


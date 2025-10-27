; unsigned char esx_f_rewinddir(unsigned char handle)

SECTION code_esxdos

PUBLIC esx_f_rewinddir

EXTERN asm_esx_f_rewinddir

defc esx_f_rewinddir = asm_esx_f_rewinddir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_rewinddir
defc _esx_f_rewinddir = esx_f_rewinddir
ENDIF


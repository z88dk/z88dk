; unsigned char esx_f_rewinddir(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_rewinddir_fastcall

EXTERN asm_esx_f_rewinddir

defc _esx_f_rewinddir_fastcall = asm_esx_f_rewinddir

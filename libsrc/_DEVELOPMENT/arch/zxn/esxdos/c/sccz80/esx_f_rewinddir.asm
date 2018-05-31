; unsigned char esx_f_rewinddir(unsigned char handle)

SECTION code_esxdos

PUBLIC esx_f_rewinddir

EXTERN asm_esx_f_rewinddir

defc esx_f_rewinddir = asm_esx_f_rewinddir

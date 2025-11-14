; unsigned char esx_f_rewinddir(unsigned char handle)

SECTION code_esxdos

PUBLIC _esx_f_rewinddir

EXTERN asm_esx_f_rewinddir

_esx_f_rewinddir:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_esx_f_rewinddir

; uchar errno_from_esxdos(uchar code)

SECTION code_clib
SECTION code_esxdos

PUBLIC _errno_from_esxdos

EXTERN asm_errno_from_esxdos

_errno_from_esxdos:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_errno_from_esxdos

; uchar esxdos_f_readdir(uchar handle, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC esxdos_f_readdir

EXTERN asm_esxdos_f_readdir

esxdos_f_readdir:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   ld a,c
   jp asm_esxdos_f_readdir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esxdos_f_readdir
defc _esxdos_f_readdir = esxdos_f_readdir
ENDIF


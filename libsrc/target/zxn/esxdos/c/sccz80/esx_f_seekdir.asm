; unsigned char esx_f_seekdir(unsigned char handle,uint32_t pos)

SECTION code_esxdos

PUBLIC esx_f_seekdir

EXTERN asm_esx_f_seekdir

esx_f_seekdir:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   ld a,l
   jp asm_esx_f_seekdir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_seekdir
defc _esx_f_seekdir = esx_f_seekdir
ENDIF


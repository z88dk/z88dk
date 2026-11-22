; unsigned char esx_f_ftrunc(unsigned char handle, uint32_t size)

SECTION code_esxdos

PUBLIC esx_f_ftrunc

EXTERN asm_esx_f_ftrunc

esx_f_ftrunc:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   ld a,l
   jp asm_esx_f_ftrunc

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_ftrunc
defc _esx_f_ftrunc = esx_f_ftrunc
ENDIF


; uint32_t esx_f_seek(unsigned char handle, uint32_t distance, unsigned char whence)

SECTION code_esxdos

PUBLIC esx_f_seek

EXTERN asm_esx_f_seek

esx_f_seek:

   pop af
   pop hl
   pop de
   pop bc
   pop ix
   
   push bc
   push bc
   push de
   push hl
   push af
   
   ld a,ixl
   jp asm_esx_f_seek

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_seek
defc _esx_f_seek = esx_f_seek
ENDIF


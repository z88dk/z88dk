; uint16_t esx_f_read(unsigned char handle, void *dst, size_t nbytes)

SECTION code_esxdos

PUBLIC esx_f_read

EXTERN asm_esx_f_read

esx_f_read:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   ld a,e
   jp asm_esx_f_read

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_read
defc _esx_f_read = esx_f_read
ENDIF


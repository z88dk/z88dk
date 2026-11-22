; uint16_t esx_f_write(unsigned char handle, void *src, size_t nbytes)

SECTION code_esxdos

PUBLIC esx_f_write

EXTERN asm_esx_f_write

esx_f_write:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   ld a,e
   jp asm_esx_f_write

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_write
defc _esx_f_write = esx_f_write
ENDIF


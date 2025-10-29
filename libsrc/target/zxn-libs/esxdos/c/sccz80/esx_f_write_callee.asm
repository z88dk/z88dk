; uint16_t esx_f_write(unsigned char handle, void *src, size_t nbytes)

SECTION code_esxdos

PUBLIC esx_f_write_callee

EXTERN asm_esx_f_write

esx_f_write_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   ld a,e
   jp asm_esx_f_write

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_write_callee
defc _esx_f_write_callee = esx_f_write_callee
ENDIF


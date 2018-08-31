; uint16_t esx_f_read(unsigned char handle, void *dst, size_t nbytes)

SECTION code_esxdos

PUBLIC esx_f_read_callee

EXTERN asm_esx_f_read

esx_f_read_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   ld a,e
   jp asm_esx_f_read

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _esx_f_read_callee
defc _esx_f_read_callee = esx_f_read_callee
ENDIF


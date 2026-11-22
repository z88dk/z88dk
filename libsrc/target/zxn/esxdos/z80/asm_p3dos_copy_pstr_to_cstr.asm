; unsigned char *p3dos_copy_pstr_to_cstr(char *cdst, const char *psrc)

SECTION code_esxdos

PUBLIC asm_p3dos_copy_pstr_to_cstr

asm_p3dos_copy_pstr_to_cstr:

   ; enter : hl = char *psrc (ff terminated string)
   ;         de = char *cdst (copy destination, will be zero terminated)
   ;
   ; exit  : hl = char *cdst
   ;         de = ptr to terminating zero in cdst
   ;
   ; uses  : af, bc, de, hl

   push de
   ld a,$ff

loop:

   cp (hl)
   ldi
   
   jr nz, loop

done:

   xor a
   
   dec de
   ld (de),a
   
   pop hl
   ret

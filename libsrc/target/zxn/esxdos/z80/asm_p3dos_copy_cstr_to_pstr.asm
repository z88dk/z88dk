; unsigned char *p3dos_copy_cstr_to_pstr(char *pdst, const char *csrc)

SECTION code_esxdos

PUBLIC asm_p3dos_copy_cstr_to_pstr

asm_p3dos_copy_cstr_to_pstr:

   ; enter : hl = char *csrc (zero terminated string)
   ;         de = char *pdst (copy destination, will be ff terminated)
   ;
   ; exit  : hl = char *pdst
   ;         de = ptr to terminating ff in pdst
   ;
   ; uses  : af, bc, de, hl

   push de
   xor a

loop:

   cp (hl)
   ldi
   
   jr nz, loop

done:

   ld a,$ff
   
   dec de
   ld (de),a
   
   pop hl
   ret

; unsigned char *p3dos_cstr_to_pstr(unsigned char *s)

SECTION code_esxdos

PUBLIC asm_p3dos_cstr_to_pstr

asm_p3dos_cstr_to_pstr:

   ; change string termination from 0xff to 0x00
   ;
   ; enter : hl = char *s
   ;
   ; exit  : hl = char *s
   ;
   ; uses  : af, bc
   
   xor a
   
   push hl
   
   ld c,a
   ld b,a
   
   cpir
   
   dec hl
   ld (hl),$ff
   
   pop hl

   ret

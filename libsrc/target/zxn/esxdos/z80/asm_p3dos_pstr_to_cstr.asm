; unsigned char *p3dos_pstr_to_cstr(unsigned char *s)

SECTION code_esxdos

PUBLIC asm_p3dos_pstr_to_cstr

asm_p3dos_pstr_to_cstr:

   ; change string termination from 0xff to 0x00
   ;
   ; enter : hl = char *s
   ;
   ; exit  : hl = char *s
   ;
   ; uses  : af, bc
   
   ld a,$ff
   
   push hl
   
   ld bc,0
   cpir
   
   dec hl
   ld (hl),0
   
   pop hl

   ret

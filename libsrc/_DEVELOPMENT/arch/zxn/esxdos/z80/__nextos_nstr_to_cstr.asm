SECTION code_esxdos

PUBLIC __nextos_nstr_to_cstr

__nextos_nstr_to_cstr:

   ; change string termination from 0xff to 0x00
   ;
   ; enter : hl = char *s
   ;
   ; exit  : hl = char *s at terminator
   ;
   ; uses  : af, bc, hl
   
   ld a,$ff
   
   ld bc,0
   cpir
   
   dec hl
   ld (hl),0
   
   ret

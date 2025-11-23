; unsigned char ulap_pent_from_attr_ink(unsigned char attr)

SECTION code_clib
SECTION code_arch

PUBLIC asm_ulap_pent_from_attr_ink

asm_ulap_pent_from_attr_ink:

   ; enter : l = unsigned char attr
   ;
   ; exit  : l = palette entry
   ;
   ; uses  : af, hl

   ld a,l
   and $07
   ld h,a
   
   ld a,l
   and $c0
   rra
   rra
   
   or h
   ld l,a
   
   ret

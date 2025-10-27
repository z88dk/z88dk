; unsigned char ulap_pent_from_attr_paper(unsigned char attr)

SECTION code_clib
SECTION code_arch

PUBLIC asm_ulap_pent_from_attr_paper

asm_ulap_pent_from_attr_paper:

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
   
   add a,$08
   
   or h
   ld l,a
   
   ret

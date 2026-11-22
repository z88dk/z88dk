; unsigned char ulap_attr_from_pentp_penti(unsigned char pentp,unsigned char penti)

SECTION code_clib
SECTION code_arch

PUBLIC asm_ulap_attr_from_pentp_penti

asm_ulap_attr_from_pentp_penti:

   ; enter : l = unsigned char pentp
   ;         h = unsigned char penti
   ;
   ; exit  : l = attribute value
   ;
   ; uses  : af, hl

   ld a,h
   and $07
   ld h,a
   
   ld a,l
   add a,a
   add a,a
   ld l,a
   
   and $c0
   or h
   ld h,a
   
   ld a,l
   add a,a
   and $38
   
   or h
   ld l,a
   
   ret

;
;       Small C+ TCP Implementation
;
;       htonl() Convert host to network format and back again!
;
;       djm 24/4/99

SECTION code_clib
SECTION code_l_sccz80

PUBLIC htonl

htonl:
   ld a,l                      ; swap within bytes
   ld l,d
   ld d,a
   ld a,h
   ld h,e
   ld e,a
   ret

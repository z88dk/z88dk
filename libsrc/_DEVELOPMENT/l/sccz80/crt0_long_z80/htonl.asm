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

   ex de,hl                    ; exchange order of bytes
   
   ld a,l                      ; swap within bytes
   ld l,h
   ld h,a
   ld a,e
   ld e,d
   ld d,a
   
   ret

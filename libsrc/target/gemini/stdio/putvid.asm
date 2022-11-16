; 11.2022 stefano

; void __FASTCALL__ putvid(unsigned chat chr)

SECTION code_clib

PUBLIC putvid
PUBLIC _putvid

PUBLIC putvid_a


putvid:
_putvid:
   in a,(0xB2)
   rrca
   jr c,putvid
   ld a,l
   out (0xB1),a
   ret

putvid_a:
   push hl
   ld l,a
   call putvid
   pop hl
   ret

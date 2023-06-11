; 11.2022 stefano

; unsigned char getvid()

SECTION code_clib

PUBLIC getvid
PUBLIC _getvid

PUBLIC getvid_a


getvid:
_getvid:
   call getvid_a
   ld l,a
   ret

getvid_a:
   in a,(0xB2)
   rlca
   jr c,getvid
   in a,(0xB1)
   ret

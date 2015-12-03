;       Small C+ Z88 Support Library
;
;       Convert signed long to int
;       NB. This routine will only work if long < +/-32767ish (obvious)

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long2int_s

l_long2int_s:

   ; copy sign of d into h
   
   ld a,d
   xor h
   ret p
   
   and $80
   xor h
   ld h,a
   
   ret

;       Small C+ Z88 Support Library
;
;       Convert signed long to int
;       NB. This routine will only work if long < +/-32767ish (obvious)


                SECTION   code_crt0_sccz80
PUBLIC l_long2int_s

;This routine picks up the sign in d (MSB) sticks into the MSB of h
;Perhaps this routine could be inlined? Certainly short enough!

.l_long2int_s

   ld a,d
   xor h
   ret p
   and $80
   xor h
   ld h,a
   ret

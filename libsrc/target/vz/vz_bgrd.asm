;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __FASTCALL__ vz_bgrd(int n)

SECTION code_clib
PUBLIC vz_bgrd
PUBLIC _vz_bgrd

.vz_bgrd
._vz_bgrd

   ld a,h
   or l
   ld hl,$783b
   ld a,(hl)
   set 4,a
   jr nz, bgrd1
   and $ef                   ; res 4,a
 
.bgrd1
 
   ld (hl),a
   ld ($6800),a
   ret

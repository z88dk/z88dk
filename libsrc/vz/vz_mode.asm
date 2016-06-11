;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void __FASTCALL__ vz_mode(int n)

SECTION code_clib
PUBLIC vz_mode
PUBLIC _vz_mode

.vz_mode
._vz_mode

   ld a,h
   or l
   ld hl,$783b
   ld a,(hl)
   jr nz, mode1
   
.mode0

   and $f7                   ; res 3,a
   ld (hl),a
   ld ($6800),a
   ld ($783b),a
   jp $01c9                  ; cls

.mode1

   or $08                    ; set 3,a
   ld (hl),a
   ld ($6800),a
   ld ($783b),a
   
   ld hl,$7000
   ld de,$7001
   ld bc,$7ff
   ld (hl),0
   ldir
   ret

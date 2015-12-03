
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int ffsl(long i)
;
; Return bit position of least significant bit set.  Bit
; positions are numbered 1-32 with 0 returned if no bits
; are set.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_ffsl

EXTERN asm0_ffs, asm1_ffs, asm2_ffs

asm_ffsl:

   ; enter : dehl = long
   ;
   ; exit  : hl = bit pos or 0 if no set bits
   ;         carry set if set bit present
   ;
   ; uses  : af, hl

   ld a,l
   or a
   jp nz, asm0_ffs
   
   ld a,h
   or a
   jp nz, asm1_ffs
   
   ld a,e
   or a
   jr nz, bits_17_24
   
   ld a,d
   or a
   ret z

bits_25_32:

   ld l,25
   jp asm2_ffs

bits_17_24:

   ld l,17
   jp asm2_ffs

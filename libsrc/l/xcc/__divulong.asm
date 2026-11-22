SECTION code_clib
SECTION code_l_xcc

PUBLIC __div32
PUBLIC __divulong

EXTERN l_divu_32_32x32

; 32-bit unsigned division (xcc sdcccall(1) runtime ABI).
;
; enter : de:hl = x  (dividend, DE=low16, HL=high16)
;         y at 4(ix)..7(ix) (divisor, lsb..msb)
; exit  : de:hl = quotient (DE=low16, HL=high16)
; uses  : af, bc, de, hl, ix, alt regs
;
; z88dk l_divu_32_32x32 spec: dehl (main) = divisor, dehl' (shadow) = dividend
;                             exit dehl = quotient, dehl' = remainder.

__div32:
__divulong:
   push ix
   ld ix,0
   add ix,sp

   ex de,hl                    ; bank A: DE=hi(x), HL=lo(x)  — z88dk dividend
   exx                         ; park dividend in shadow; bank B active

   ld l,(ix+4)
   ld h,(ix+5)                 ; HL = y_low_word
   ld e,(ix+6)
   ld d,(ix+7)                 ; DE = y_high_word — bank B holds divisor (z88dk)

   call l_divu_32_32x32        ; bank B = quotient, bank A (shadow) = remainder

   ex de,hl                    ; bank B: xcc order quotient
   push hl
   push de
   exx                         ; bank A active
   pop de
   pop hl                      ; bank A = xcc order quotient

   pop ix
   ret

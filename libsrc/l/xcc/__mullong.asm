SECTION code_clib
SECTION code_l_xcc

PUBLIC __mul32
PUBLIC __mullong

EXTERN l_mulu_32_32x32

; 32-bit multiplication (xcc sdcccall(1) runtime ABI).
;
; enter : de:hl = x  (DE = low16, HL = high16 — xcc convention)
;         y at 4(ix)..7(ix) after `push ix; ld ix, sp` (lsb..msb)
; exit  : de:hl = product low 32 (DE = low16, HL = high16)
; uses  : af, bc, de, hl, ix, alt regs
;
; z88dk l_mulu_32_32x32 uses DE = high16, HL = low16, second op in DEHL' shadow.
; Wrapper flow:
;   1. ex de,hl        : convert x to z88dk order in bank A
;   2. exx             : x now in shadow bank; caller's "other" bank (B) is active
;   3. load y from stack into active bank in z88dk order
;   4. call l_mulu_32_32x32   : main (B) = mcand, shadow (A) = mplier → main (B) = product
;   5. ex de,hl        : convert product to xcc order
;   6. push/exx/pop    : shuttle product back to bank A so caller sees it in original main

__mul32:
__mullong:
   push ix
   ld ix,0
   add ix,sp                   ; ix = sp; 4(ix)..7(ix) = y bytes (lsb..msb)

   ex de,hl                    ; bank A: DE=hi(x), HL=lo(x)  — z88dk order
   exx                         ; bank B now active; x parked in shadow

   ld l,(ix+4)
   ld h,(ix+5)                 ; HL = y_low_word
   ld e,(ix+6)
   ld d,(ix+7)                 ; DE = y_high_word — bank B in z88dk order

   call l_mulu_32_32x32        ; bank B = product (z88dk)

   ex de,hl                    ; bank B: DE=lo, HL=hi  — xcc order
   push hl
   push de
   exx                         ; back to bank A (clobbered by mul; product on stack)
   pop de
   pop hl                      ; bank A = product (xcc order)

   pop ix
   ret

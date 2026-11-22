SECTION code_clib
SECTION code_l_xcc

PUBLIC __mod32
PUBLIC __modulong

EXTERN l_divu_32_32x32

; 32-bit unsigned modulus (xcc sdcccall(1) runtime ABI).
; After l_divu_32_32x32, shadow bank already holds the remainder — one exx
; brings it home; then ex de,hl to xcc order.

__mod32:
__modulong:
   push ix
   ld ix,0
   add ix,sp

   ex de,hl                    ; bank A: z88dk dividend
   exx                         ; park dividend in shadow

   ld l,(ix+4)
   ld h,(ix+5)
   ld e,(ix+6)
   ld d,(ix+7)                 ; bank B: z88dk divisor

   call l_divu_32_32x32        ; bank B = quotient, bank A = remainder

   exx                         ; bank A active with z88dk remainder
   ex de,hl                    ; xcc order

   pop ix
   ret

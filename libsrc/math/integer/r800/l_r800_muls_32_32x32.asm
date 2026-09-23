; r800 override for l_muls_32_32x32 - sign-magnitude wrapper around
; l_r800_mulu_32_32x32 (r800's muluw is unsigned-only hardware), same
; abs/negate idiom as l_r800_muls_16_16x16.asm / l_r800_muls_32_16x16.asm.

SECTION code_clib
SECTION code_math

EXTERN l_r800_mulu_32_32x32
EXTERN l_neg_dehl

PUBLIC l_r800_muls_32_32x32
PUBLIC l_muls_32_32x32

   ; compute:  dehl = dehl * dehl'  (signed)
   ;
   ; enter : de hl  = 32-bit operand B (active set)
   ;         de'hl' = 32-bit operand A (exx set)
   ;
   ; exit  : dehl = 32-bit product, carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

l_r800_muls_32_32x32:
l_muls_32_32x32:

    ld a,d                       ; B_hi sign byte
    exx
    xor d                        ; ^= A_hi sign byte -> bit 7 = sign(A) xor sign(B)
    exx                          ; back to active=B, exx=A (l_r800_mulu_32_32x32's entry contract)
    push af                      ; stash the combined sign - survives the balanced call below

    ld a,d
    or a
    call M,l_neg_dehl            ; take absolute value of B

    exx
    ld a,d
    or a
    call M,l_neg_dehl            ; take absolute value of A
    exx                          ; restore active=B, exx=A

    call l_r800_mulu_32_32x32

    pop af
    or a
    jp M,l_neg_dehl               ; negate the product if the signs differed
    ret

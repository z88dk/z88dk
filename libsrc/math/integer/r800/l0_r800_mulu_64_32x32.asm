; r800 override for l0_mulu_64_32x32 - the widening 32x32->64 kernel that
; l_fast_mulu_64_64x64.asm/l_small_mul_64_64x64.asm call directly (not
; through the l_mulu_64_32x32 wrapper) as a building block for 64-bit
; ("long long") multiply. r800 objects stay z80-stamped, so the
; __CPU_KC160__/... dispatch in the generic l_mulu_64_32x32.asm can't
; reach r800 - this file's PUBLIC l0_mulu_64_32x32 overrides it directly.
;
; Structurally identical to l_kc160_mulu_64_32x32.asm's l0_ kernel (same
; AB*CD = (A*C<<32) + ((A*D+B*C)<<16) + B*D decomposition, same ix-relative
; accumulator), with muluw hl,de standing in for kc160's mul de,hl.
;
; z80asm has no muluw mnemonic; $ED,$D3 is `muluw hl,de` raw-encoded.

SECTION code_clib
SECTION code_math

PUBLIC l0_r800_mulu_64_32x32
PUBLIC l0_mulu_64_32x32

   ; multiplication of two 32-bit numbers into a 64-bit product
   ;
   ; enter : de'de = 32-bit multiplier    = x  (de = B, de' = A)
   ;         bc'bc = 32-bit multiplicand  = y  (bc = D, bc' = C)
   ;
   ; exit  : dehl dehl' = 64-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

l0_r800_mulu_64_32x32:
l0_mulu_64_32x32:

; AB * CD = (A*C << 32) + ((B*C + A*D) << 16) + B*D

    push ix
    ld ix,0
    add ix,sp        ; z80 has no `ld ix,sp`
    push bc    ;(ix-2) = D
    exx
    push bc    ;(ix-4) = C
    exx
    push de    ;(ix-6) = B
    exx
    push de    ;(ix-8) = A
    ld hl,0
    push hl    ;(ix-10) = LSB result
    push hl    ;(ix-12) = MSB result
    push hl    ;(ix-14) = MLSB result
    push hl    ;(ix-16) = MMSB result

    ;(B*D)
    ld hl,(ix-6)
    ld de,(ix-2)
    defb $ED,$D3          ; muluw hl,de
    ld (ix-10),hl
    ld (ix-12),de

    ;(A*D) << 16
    ld hl,(ix-8)
    ld de,(ix-2)
    defb $ED,$D3          ; muluw hl,de
    ld bc,(ix-12)
    add hl,bc
    ld (ix-12),hl
    ld hl,(ix-14)
    adc hl,de
    ld (ix-14),hl

    ;(B*C) << 16
    ld hl,(ix-6)
    ld de,(ix-4)
    defb $ED,$D3          ; muluw hl,de
    ld bc,(ix-12)
    add hl,bc
    ld (ix-12),hl
    ld hl,(ix-14)
    adc hl,de
    ld (ix-14),hl
    ld hl,(ix-16)
    ld de,0
    adc hl,de
    ld (ix-16),hl

    ; (A*C << 32)
    ld hl,(ix-8)
    ld de,(ix-4)
    defb $ED,$D3          ; muluw hl,de
    ld bc,(ix-14)
    add hl,bc
    ld (ix-14),hl
    ld hl,(ix-16)
    adc hl,de
    ld (ix-16),hl

    ; exit  : dehl dehl' = 64-bit product
    ld hl,(ix-10)
    ld de,(ix-12)
    exx
    ld hl,(ix-14)
    ld de,(ix-16)

    ld sp,ix
    pop ix
    and a
    ret

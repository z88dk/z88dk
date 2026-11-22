; r800 override for l_mulu_32_32x32 (see l_r800_muls_32_32x32.asm for the
; signed wrapper). r800 objects stay z80-stamped (no __CPU_R800__ at
; z80asm level), so the __CPU_KC160__/__CPU_Z80N__/... dispatch in the
; generic l_mulu_32_32x32.asm can't reach r800 - this file's PUBLIC
; l_mulu_32_32x32 overrides it directly (link -lr800_opt before the
; default clib, see zcc.c).
;
; Built from three muluw hl,de 16x16->32 hardware partials instead of the
; 8x8 `mul` partials the other CPUs' l_*_mulu_32_32x32 use:
;   result_lo16 = low16(A_lo*B_lo)
;   result_hi16 = high16(A_lo*B_lo) + low16(A_lo*B_hi) + low16(A_hi*B_lo)
;                 (mod 2^16, overflow beyond bit 31 discarded)
;
; z80asm has no muluw mnemonic; $ED,$D3 is `muluw hl,de` raw-encoded.

SECTION code_clib
SECTION code_math

PUBLIC l_r800_mulu_32_32x32
PUBLIC l_mulu_32_32x32

   ; compute:  dehl = dehl * dehl'
   ;
   ; enter : de hl  = 32-bit operand B (active set)
   ;         de'hl' = 32-bit operand A (exx set)
   ;
   ; exit  : dehl = 32-bit product, carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

l_r800_mulu_32_32x32:
l_mulu_32_32x32:

    ; stash the six operand halves needed for the three partials, in the
    ; order they'll be popped: A_lo,B_hi, A_hi,B_lo, A_lo,B_lo
    push hl                     ; B_lo
    exx
    push hl                     ; A_lo
    exx
    push hl                     ; B_lo
    exx
    push de                     ; A_hi
    exx
    push de                     ; B_hi
    exx
    push hl                     ; A_lo
    exx

    ; mul2: A_lo * B_hi -> only the low word matters (16-bit accumulator seed)
    pop hl
    pop de
    defb $ED,$D3                ; muluw hl,de
    ld b,h
    ld c,l

    ; mul3: A_hi * B_lo -> low word, add into the accumulator
    pop hl
    pop de
    defb $ED,$D3                ; muluw hl,de
    ld a,c
    add a,l
    ld c,a
    ld a,b
    adc a,h
    ld b,a

    ; mul1: A_lo * B_lo -> full 32-bit; low word is the final answer as-is,
    ; high word adds into the same accumulator
    pop hl
    pop de
    defb $ED,$D3                ; muluw hl,de
    ld a,e
    add a,c
    ld e,a
    ld a,d
    adc a,b
    ld d,a

    xor a                        ; carry reset
    ret                          ; dehl = 32-bit product

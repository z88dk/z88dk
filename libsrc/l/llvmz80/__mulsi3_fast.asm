
; ravn/llvm-z80 #283: -O3 fast variant of the 32-bit multiply bridge.
;
; Identical to ___mulsi3 (see __mulsi3.asm) except it calls the SIGNED core
; l_muls_32_32x32 instead of the unsigned l_mulu_32_32x32.  The signed core
; (l_small_muls_32_32x32 on the small model) takes the magnitude of each
; operand first (hi word -> 0x0000 for a value that fits 16 bits), which then
; hits the 32->16x16 demote fast path in l_small_mul_32_32x32.  The low 32 bits
; of a signed vs unsigned product are identical, so this is a correct drop-in
; for every 32-bit multiply; it is only selected at -O3 (see Z80ISelLowering.cpp
; setLibcallName MUL_I32) as a speculative speed win for the (long)i16*i16
; fixed-point case, at the cost of a small abs/negate overhead on genuine
; 32-bit operands.
;
;   clang ABI : one 32-bit operand in HL:DE (HL=high, DE=low); the other pushed
;               on the stack (lo word, then hi word; caller-cleaned); IX = frame
;               ptr (preserve). exit: 32-bit product in HL:DE.
;   core ABI  : dehl = dehl * dehl' (DE:HL layout, DE=high, HL=low); one factor
;               in the main bank, the other in the alternate bank.  Trashes IX.

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l_clang

PUBLIC ___mulsi3_fast

EXTERN l_muls_32_32x32

___mulsi3_fast:
   ex de,hl                     ; llvm-z80 HL:DE -> core DE:HL (register factor)
   exx                          ; dehl' = register factor (into alternate bank)
   push ix                      ; save caller frame ptr (core trashes IX)
   ld ix,0
   add ix,sp                    ; IX -> [saved IX]; +2 ret, +4 lo word, +6 hi word
   ld l,(ix+4)
   ld h,(ix+5)                  ; HL = stack factor low word (core low)
   ld e,(ix+6)
   ld d,(ix+7)                  ; main dehl = stack factor (DE=hi, HL=lo)
   call l_muls_32_32x32         ; main dehl = signed product (low 32 bits == unsigned)
   pop ix                       ; restore caller frame ptr
   ex de,hl                     ; core DE:HL -> llvm-z80 HL:DE (product)
   ret

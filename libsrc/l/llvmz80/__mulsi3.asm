
; ravn/llvm-z80 compiler-rt 32-bit integer multiply helper.
;
; The backend calls __mulsi3 for 32-bit `long` multiply.  The low 32 bits of a
; product are identical for signed and unsigned operands, so a single unsigned
; core (l_mulu_32_32x32) serves both; this bridge adapts clang's ABI to it.
;
;   clang ABI : one 32-bit operand in HL:DE (HL=high, DE=low); the other pushed
;               on the stack (lo word, then hi word; caller-cleaned); IX = frame
;               ptr (preserve). exit: 32-bit product in HL:DE.
;   core ABI  : dehl = dehl * dehl' (DE:HL layout, DE=high, HL=low); one factor
;               in the main bank, the other in the alternate bank.  Trashes IX.
;
; clang's HL:DE is the half-swap of the core's DE:HL, so one `ex de,hl` converts
; each way.  Multiply is commutative, so which factor is register vs stack does
; not matter.  Mirrors the ___udivsi3 bridge in __divsi3.asm.

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l_clang

PUBLIC ___mulsi3

EXTERN l_mulu_32_32x32

___mulsi3:
   ex de,hl                     ; llvm-z80 HL:DE -> core DE:HL (register factor)
   exx                          ; dehl' = register factor (into alternate bank)
   push ix                      ; save caller frame ptr (core trashes IX)
   ld ix,0
   add ix,sp                    ; IX -> [saved IX]; +2 ret, +4 lo word, +6 hi word
   ld l,(ix+4)
   ld h,(ix+5)                  ; HL = stack factor low word (core low)
   ld e,(ix+6)
   ld d,(ix+7)                  ; main dehl = stack factor (DE=hi, HL=lo)
   call l_mulu_32_32x32         ; main dehl = product
   pop ix                       ; restore caller frame ptr
   ex de,hl                     ; core DE:HL -> llvm-z80 HL:DE (product)
   ret

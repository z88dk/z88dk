
; ravn/llvm-z80 compiler-rt 32-bit integer MULTIPLY helper for the newlib route.
;
; The backend emits __mulsi3 for 32-bit `long` multiply at every opt level, but
; neither clib provided it (`long * long` -> undefined ___mulsi3). This closes it
; for newlib by adapting the same register/bank dance as ../__divsi3.asm to the
; newlib core l_mulu_32_32x32. (Classic still lacks __mulsi3 -- separate gap.)
;
;   clang ABI : HL:DE (HL=high, DE=low). enter HL:DE=a, b pushed (b_lo, b_hi,
;               caller-cleaned), IX=frame ptr (preserve). exit HL:DE=product low32.
;   core ABI  : dehl = dehl * dehl' (DE:HL layout, `ex de,hl` converts;
;               multiplicand in alt bank, multiplier in main).
;
; __umulsi3 aliases __mulsi3 (low 32 bits are sign-agnostic).

SECTION code_clib
SECTION code_l_clang

PUBLIC ___mulsi3
PUBLIC ___umulsi3

EXTERN l_mulu_32_32x32

___mulsi3:
___umulsi3:
   ex de,hl                     ; llvm-z80 HL:DE -> core DE:HL (multiplicand a)
   exx                          ; dehl' = multiplicand a (into alternate bank)
   push ix                      ; save caller frame ptr (core trashes IX)
   ld ix,0
   add ix,sp                    ; IX -> [saved IX]; +2 ret, +4 b_lo, +6 b_hi
   ld l,(ix+4)
   ld h,(ix+5)                  ; HL = b_lo (core low word)
   ld e,(ix+6)
   ld d,(ix+7)                  ; main dehl = multiplier b (not popped: caller owns)
   call l_mulu_32_32x32         ; main dehl = product (low 32 bits)
   pop ix                       ; restore caller frame ptr
   ex de,hl                     ; core DE:HL -> llvm-z80 HL:DE (product)
   ret

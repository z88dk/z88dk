
; NEWLIB copy of ../__divsi3.asm, minus the `INCLUDE "config_private.inc"`
; (absent on the newlib cpm target; the file only declares SECTIONs + calls the
; cores). The 32-bit cores are bundled in the newlib archive. Built into
; llvmz80_imath.lib. Keep the body in sync with the parent if the clang SImode
; divmod ABI changes.
;
; ravn/llvm-z80 compiler-rt 32-bit integer division/remainder helpers.
;
; The backend calls __divsi3/__modsi3/__udivsi3/__umodsi3 for 32-bit `long`
; divide/modulo. z88dk ships the cores l_div[su]_32_32x32; these bridges adapt
; clang's ABI to the core ABI.
;
;   clang ABI : 32-bit in HL:DE (HL=high, DE=low). enter HL:DE=dividend a,
;               divisor b pushed (b_lo, b_hi, caller-cleaned), IX=frame ptr
;               (preserve). exit HL:DE=result.
;   core ABI  : DE:HL layout (DE=high, HL=low); dehl = dehl'/dehl,
;               dehl'=dehl'%dehl (dividend in alt bank, divisor in main).
;
; clang's HL:DE is the half-swap of the core's DE:HL, so one `ex de,hl`
; converts each way (dividend in, result out).


SECTION code_clib
SECTION code_l_clang

PUBLIC ___divsi3
PUBLIC ___modsi3
PUBLIC ___udivsi3
PUBLIC ___umodsi3

; Fused 32-bit divmod (ravn/llvm-z80#248).  When a function computes both a/b
; and a%b of the SAME 32-bit operands, the backend's legalizeCustom folds the
; pair into ONE runtime call __divmodsi4 / __udivmodsi4 (quotient returned in
; registers, remainder written through a caller pointer) instead of two full
; 32-bit divisions.  It is emitted at EVERY opt level (fusion is opt-level
; independent); the separate ___divsi3/... names above only appear when
; something (e.g. volatile operands) blocks the fusion.  See the divmod ABI
; note at ___divmodsi4 below.
PUBLIC ___divmodsi4
PUBLIC ___udivmodsi4

EXTERN l_divs_32_32x32
EXTERN l_divu_32_32x32

; ---- signed ----

___divsi3:
   ex de,hl                     ; llvm-z80 HL:DE -> core DE:HL (dividend a)
   exx                          ; dehl' = dividend a (into alternate bank)
   push ix                      ; save caller frame ptr (core trashes IX)
   ld ix,0
   add ix,sp                    ; IX -> [saved IX]; +2 ret, +4 b_lo, +6 b_hi
   ld l,(ix+4)
   ld h,(ix+5)                  ; HL = b_lo (core low word)
   ld e,(ix+6)
   ld d,(ix+7)                  ; main dehl = divisor b (not popped: caller owns)
   call l_divs_32_32x32         ; main dehl = quotient, dehl' = remainder
   pop ix                       ; restore caller frame ptr
   ex de,hl                     ; core DE:HL -> llvm-z80 HL:DE (quotient)
   ret

___modsi3:
   ex de,hl                     ; dividend a -> core layout
   exx                          ; dehl' = dividend a
   push ix
   ld ix,0
   add ix,sp
   ld l,(ix+4)
   ld h,(ix+5)
   ld e,(ix+6)
   ld d,(ix+7)                  ; main dehl = divisor b
   call l_divs_32_32x32         ; dehl' = remainder
   pop ix
   exx                          ; active dehl = remainder (core layout)
   ex de,hl                     ; -> llvm-z80 HL:DE
   ret

; ---- unsigned ----

___udivsi3:
   ex de,hl
   exx
   push ix
   ld ix,0
   add ix,sp
   ld l,(ix+4)
   ld h,(ix+5)
   ld e,(ix+6)
   ld d,(ix+7)
   call l_divu_32_32x32
   pop ix
   ex de,hl
   ret

___umodsi3:
   ex de,hl
   exx
   push ix
   ld ix,0
   add ix,sp
   ld l,(ix+4)
   ld h,(ix+5)
   ld e,(ix+6)
   ld d,(ix+7)
   call l_divu_32_32x32
   pop ix
   exx
   ex de,hl
   ret

; ---- fused divmod (quotient in registers, remainder via caller pointer) ----
;
;   quotient = __[u]divmodsi4(long dividend, long divisor, long *rem_slot)
;   enter: HL:DE = dividend (HL=high, DE=low); stack = b_lo, b_hi, &rem_slot
;          (caller-cleaned); IX = frame ptr (preserve).
;   exit : HL:DE = quotient; *rem_slot = 4-byte little-endian remainder.
;
; The core computes both in one pass (main dehl=quotient, alt dehl'=remainder;
; DE:HL layout, so `ex de,hl` converts to/from clang's HL:DE). The core trashes
; IX, so &rem_slot is read while IX is valid, stashed across the core call, then
; restored to store the remainder (brought to main bank via `exx`).

___divmodsi4:
   ex de,hl                     ; dividend HL:DE -> core DE:HL (into alt bank)
   exx                          ; dehl' = dividend a
   push ix                      ; save caller frame ptr; [ix]+2=ret,+4=b_lo,
   ld ix,0                      ;   +6=b_hi,+8=&rem_slot
   add ix,sp
   ld c,(ix+8)
   ld b,(ix+9)                  ; BC = &rem_slot (read while IX valid)
   push bc                      ; stash pointer across the (IX-trashing) core call
   ld l,(ix+4)
   ld h,(ix+5)                  ; HL = b_lo
   ld e,(ix+6)
   ld d,(ix+7)                  ; main dehl = divisor b
   call l_divs_32_32x32         ; main dehl = quotient, alt dehl' = remainder
   pop ix                       ; IX = &rem_slot (bank-independent)
   exx                          ; main <- remainder (DE=hi word, HL=lo word)
   ld (ix+0),l                  ; store remainder, little-endian
   ld (ix+1),h
   ld (ix+2),e
   ld (ix+3),d
   exx                          ; main <- quotient
   pop ix                       ; restore caller frame ptr
   ex de,hl                     ; core DE:HL -> llvm-z80 HL:DE (quotient)
   ret

___udivmodsi4:
   ex de,hl
   exx
   push ix
   ld ix,0
   add ix,sp
   ld c,(ix+8)
   ld b,(ix+9)
   push bc
   ld l,(ix+4)
   ld h,(ix+5)
   ld e,(ix+6)
   ld d,(ix+7)
   call l_divu_32_32x32
   pop ix
   exx
   ld (ix+0),l
   ld (ix+1),h
   ld (ix+2),e
   ld (ix+3),d
   exx
   pop ix
   ex de,hl
   ret

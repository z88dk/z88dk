

; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtol

EXTERN asm_strtol

strtol:
IF __CPU_INTEL__ || __CPU_GBZ80__
   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   jp  asm_strtol
ELSE
   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   push ix
   call asm_strtol
   pop ix
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtol
defc _strtol = strtol
ENDIF

; Clang (llvmz80) bridge for Classic
; __ZPROTO3N(strtol, nptr, endptr, base) -- natural order (not reversed).
;   HL = nptr, DE = endptr, [SP+0]=ret_addr, [SP+2]=base (caller does pop af after ret)
; asm_strtol expects: HL=nptr, DE=endptr, BC=base
; Returns (llvmz80 32-bit): DE=low word, HL=high word
;   asm_strtol returns sccz80 dehl: DE=high, HL=low -- bridge swaps with ex de,hl
;
; Optimized: HL and DE are already correct; IX reads base from [IX+4] without
; disturbing the register arguments at all.  ~9 instructions vs 15 for the old
; reversed-order peek bridge.
IF __CLASSIC
IF !__CPU_INTEL__ && !__CPU_GBZ80__
; llvmz80 (clang) only targets the Z80 family; this IX-based bridge is skipped
; for the IX-less CPUs (8080/8085/gbz80) so the classic library still assembles
; for them.  (Guard added during the 2026-07-23 upstream merge + lib rebuild.)
PUBLIC ___strtol
___strtol:
   push ix         ; save IX (asm_strtol uses IX)
   ld ix,0
   add ix,sp       ; IX = entry_SP-2 (after push ix)
   ld c,(ix+4)     ; base low  = [entry_SP+2]
   ld b,(ix+5)     ; base high = [entry_SP+3]
   call asm_strtol ; HL=nptr, DE=endptr, BC=base -- all from entry registers
   pop ix          ; restore IX; SP = entry_SP
   ex de,hl        ; DE=low, HL=high (llvmz80 32-bit convention)
   ret             ; SP = entry_SP+2; caller's pop af cleans base at [entry_SP+2]
ENDIF
ENDIF



; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)

IF !__CPU_INTEL__ && !__CPU_GBZ80__


SECTION code_clib
SECTION code_stdlib

PUBLIC strtoul

EXTERN asm_strtoul

strtoul:
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
   jp  asm_strtoul
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
   call asm_strtoul
   pop ix
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoul
defc _strtoul = strtoul
ENDIF

; Clang (llvmz80) bridge for Classic
; __ZPROTO3N(strtoul, nptr, endptr, base) -- natural order (not reversed).
;   HL = nptr, DE = endptr, [SP+0]=ret_addr, [SP+2]=base (caller does pop af after ret)
; asm_strtoul expects: HL=nptr, DE=endptr, BC=base
; Returns (llvmz80 32-bit): DE=low word, HL=high word
;   asm_strtoul returns sccz80 dehl: DE=high, HL=low -- bridge swaps with ex de,hl
IF __CLASSIC
PUBLIC ___strtoul
___strtoul:
   push ix         ; save IX (asm_strtoul uses IX)
   ld ix,0
   add ix,sp       ; IX = entry_SP-2 (after push ix)
   ld c,(ix+4)     ; base low  = [entry_SP+2]
   ld b,(ix+5)     ; base high = [entry_SP+3]
   call asm_strtoul ; HL=nptr, DE=endptr, BC=base -- all from entry registers
   pop ix          ; restore IX; SP = entry_SP
   ex de,hl        ; DE=low, HL=high (llvmz80 32-bit convention)
   ret             ; SP = entry_SP+2; caller's pop af cleans base at [entry_SP+2]
ENDIF

ENDIF


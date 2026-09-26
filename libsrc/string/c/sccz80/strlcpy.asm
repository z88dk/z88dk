
; size_t strlcpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strlcpy

EXTERN asm_strlcpy

strlcpy:
IF __CPU_GBZ80__ | __CPU_INTEL__
   ld hl,sp+2
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
   ex de,hl
   call asm_strlcpy
   ld d,h
   ld e,l
   ret
ELSE
   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   jp asm_strlcpy
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strlcpy
defc _strlcpy = strlcpy
ENDIF


; Clang bridge for Classic
; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO3(strlcpy, dest, src, n) -> ___strlcpy(n, src, dest): HL=n, DE=src, [SP]=dest.
; asm_strlcpy enter: HL=src, DE=dest, BC=n.
; Stack on entry: [SP] = return addr, [SP+2] = dest (callee-cleaned by ret).
IF __CLASSIC
PUBLIC ___strlcpy
___strlcpy:
   ld c,l
   ld b,h                   ; BC = n
   pop hl                   ; HL = return address
   ex (sp),hl               ; HL = dest, [SP] = return address
   ex de,hl                 ; DE = dest, HL = src (was in DE)
   call asm_strlcpy         ; enter HL=src, DE=dest, BC=n; exit HL=strlen(src)
   ex de,hl                 ; DE = result (C return value)
   ret
ENDIF


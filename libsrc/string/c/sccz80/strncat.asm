
; char *strncat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncat

EXTERN asm_strncat

strncat:
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
   ld l,e
   ld e,a
   ld a,d
   ld d,h
   ld h,a
   call asm_strncat
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
   jp asm_strncat
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncat
defc _strncat = strncat
ENDIF


; Clang bridge for Classic
; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO3(strncat, dst, src, n) -> ___strncat(n, src, dst): HL=n, DE=src, [SP]=dst.
; asm_strncat enter: HL=src, DE=dst, BC=n.
; Stack on entry: [SP] = return addr, [SP+2] = dst (callee-cleaned by ret).
IF __CLASSIC
PUBLIC ___strncat
___strncat:
   ld c,l
   ld b,h                   ; BC = n
   pop hl                   ; HL = return address
   ex (sp),hl               ; HL = dst, [SP] = return address
   ex de,hl                 ; DE = dst, HL = src (was in DE)
   call asm_strncat         ; enter HL=src, DE=dst, BC=n; exit HL=dst
   ex de,hl                 ; DE = dst (C return value)
   ret
ENDIF


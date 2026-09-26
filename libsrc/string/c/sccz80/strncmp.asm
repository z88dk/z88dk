
; int strncmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncmp

EXTERN asm_strncmp

strncmp:
IF __CPU_GBZ80__ | __CPU_INTEL__
   ld hl,sp+2
   ld c,(hl)	;n
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)	;s2
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl+)	;s1
   ld h,(hl)
   ld l,e
   ld e,a
   ld a,d
   ld d,h
   ld h,a
   call asm_strncmp
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
   jp asm_strncmp
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncmp
defc _strncmp = strncmp
ENDIF


; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO3(strncmp, s1, s2, n) -> ___strncmp(n, s2, s1): HL=n, DE=s2, [SP+2]=s1.
; asm_strncmp enter: BC=n, DE=s1, HL=s2. exit: HL=diff.
; Bridge-cleans: consumes s1 via ret (no caller pop af). Result in DE.
IF __CLASSIC
PUBLIC ___strncmp
___strncmp:
   ld c,l
   ld b,h                   ; BC = n
   pop hl                   ; HL = return address
   ex (sp),hl               ; HL = s1, [SP] = return address (bridge-cleans)
   ex de,hl                 ; DE = s1, HL = s2 (was in DE)
   call asm_strncmp         ; BC=n, DE=s1, HL=s2 -> HL=diff
   ex de,hl                 ; DE = diff (llvmz80 16-bit int return in DE)
   ret
ENDIF


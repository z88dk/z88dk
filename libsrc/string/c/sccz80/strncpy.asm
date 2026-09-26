
; char *strncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncpy

EXTERN asm_strncpy

strncpy:
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
   call asm_strncpy
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
   jp asm_strncpy
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncpy
defc _strncpy = strncpy
ENDIF


; Clang bridge for Classic (llvmz80 reversed-arg register ABI).
; __strncpy(size_t n, const char *s2, char *s1): HL=n, DE=s2 (src),
; s1 (dst) on the stack above the return address, callee-cleaned;
; return dst in DE.
IF __CLASSIC
PUBLIC ___strncpy
___strncpy:
   ld c,l
   ld b,h                   ; BC = n
   pop hl                   ; HL = return address
   ex (sp),hl               ; HL = s1 (dst); [SP] = return address
   ex de,hl                 ; DE = dst, HL = src (s2)
   call asm_strncpy         ; enter DE=dst, HL=src, BC=n; exit HL=dst
   ex de,hl                 ; DE = dst (C return value)
   ret
ENDIF


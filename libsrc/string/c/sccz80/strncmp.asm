
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


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strncmp
defc ___strncmp = strncmp
ENDIF


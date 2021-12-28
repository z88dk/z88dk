
; char *strnchr(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

PUBLIC strnchr

EXTERN asm_strnchr

strnchr:
IF __CPU_GBZ80__ | __CPU_INTEL__
   ld hl,sp+2
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   call asm_strnchr
   ld d,h
   ld e,l
   ret
ELSE

   pop af
   pop de
   pop bc
   pop hl

   push hl
   push bc
   push de
   push af
   jp asm_strnchr
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnchr
defc _strnchr = strnchr
ENDIF


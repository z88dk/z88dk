
; char *strnchr(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

PUBLIC strnchr

EXTERN asm_strnchr

strnchr:
IF __CPU_INTEL__ || __CPU_GBZ80__
   ld hl,sp+2
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
IF __CPU_GBZ80__
   ld a,(hl+)
ELSE
   ld a,(hl)
   inc hl
ENDIF
   ld h,(hl)
   ld l,a
   call asm_strnchr
   ld de,hl
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


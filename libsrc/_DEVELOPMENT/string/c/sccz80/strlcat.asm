
; size_t strlcat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strlcat

EXTERN asm_strlcat

strlcat:
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
   call asm_strlcat
   ld de,hl
   ret
ELSE
   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   jp asm_strlcat
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strlcat
defc _strlcat = strlcat
ENDIF


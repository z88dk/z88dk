
; size_t strxfrm(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strxfrm

EXTERN asm_strxfrm

strxfrm:
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
   ld l,e
   ld e,a
   ld a,d
   ld d,h
   ld h,a
   call asm_strxfrm
   ld de,hl
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
   jp asm_strxfrm
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strxfrm
defc _strxfrm = strxfrm
ENDIF


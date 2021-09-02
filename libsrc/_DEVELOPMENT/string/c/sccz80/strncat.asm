
; char *strncat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncat

EXTERN asm_strncat

strncat:
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
   call asm_strncat
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
   jp asm_strncat
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncat
defc _strncat = strncat
ENDIF



; char *strnset(char *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strnset

EXTERN asm_strnset

strnset:
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
   call asm_strnset
   ld d,h
   ld e,l
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
   jp asm_strnset
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnset
defc _strnset = strnset
ENDIF


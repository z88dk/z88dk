
; void *memswap(void *s1, void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memswap

EXTERN asm_memswap

memswap:
IF __CPU_GBZ80__
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
ELSE

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
ENDIF
   
   jp asm_memswap

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memswap
defc _memswap = memswap
ENDIF


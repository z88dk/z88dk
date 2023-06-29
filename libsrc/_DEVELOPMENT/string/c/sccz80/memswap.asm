
; void *memswap(void *s1, void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memswap

EXTERN asm_memswap

memswap:
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
  
IF __CLASSIC && __CPU_GBZ80__
   call asm_memswap
   ld d,h
   ld e,l
   ret
ELSE 
   jp asm_memswap
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memswap
defc _memswap = memswap
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___memswap
defc ___memswap = memswap
ENDIF


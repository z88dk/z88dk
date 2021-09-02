
; void *memswap(void *s1, void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memswap

EXTERN asm_memswap

memswap:
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
   ld de,hl
   ret
ELSE 
   jp asm_memswap
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memswap
defc _memswap = memswap
ENDIF


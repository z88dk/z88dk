
; void *memset(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memset

EXTERN asm_memset

memset:
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
   call asm_memset
   ld de,hl
   ret
ELSE 
   jp asm_memset
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memset
defc _memset = memset
ENDIF


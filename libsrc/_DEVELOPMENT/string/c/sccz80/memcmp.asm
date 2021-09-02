
; int memcmp(const void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memcmp

EXTERN asm_memcmp

memcmp:
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
ELSE

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
ENDIF
  
IF __CLASSIC && __CPU_GBZ80__
   call asm_memcmp
   ld de,hl
   ret
ELSE 
   jp asm_memcmp
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memcmp
defc _memcmp = memcmp
ENDIF


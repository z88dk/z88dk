
; void *memset_wr(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memset_wr

EXTERN asm_memset_wr

memset_wr:
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
   call asm_memset_wr
   ld d,h
   ld e,l
   ret
ELSE 
   jp asm_memset_wr
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memset_wr
defc _memset_wr = memset_wr
ENDIF



; void *memrchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memrchr

EXTERN l0_memrchr_callee

memrchr:
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
   call l0_memrchr_callee
   ld d,h
   ld e,l
   ret
ELSE
   jp l0_memrchr_callee
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memrchr
defc _memrchr = memrchr
ENDIF



; void *memchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memchr

EXTERN l0_memchr_callee

memchr:
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

   jp l0_memchr_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memchr
defc _memchr = memchr
ENDIF


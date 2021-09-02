
; void *memchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memchr

EXTERN l0_memchr_callee

memchr:
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
   call l0_memchr_callee
   ld de,hl
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
   jp l0_memchr_callee
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memchr
defc _memchr = memchr
ENDIF



; char *_memstrcpy_(void *p, char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC _memstrcpy_

EXTERN asm__memstrcpy

_memstrcpy_:
IF __CPU_GBZ80__ | __CPU_INTEL__
   ld  hl,sp+2
   ld  c,(hl)
   inc hl
   ld  b,(hl)
   inc hl
   ld  e,(hl)
   inc hl
   ld  d,(hl)
   inc hl
   ld a,(hl+)
   ld  h,(hl)
   ld  l,e
   ld  e,a
   ld  a,h
   ld  h,d
   ld  d,a
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
   
   jp asm__memstrcpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC __memstrcpy_
defc __memstrcpy_ = _memstrcpy_
ENDIF


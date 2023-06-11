
; BSD
; void bcopy(const void *src, void *dst, size_t len)

SECTION code_clib
SECTION code_string

PUBLIC bcopy

EXTERN asm_bcopy

bcopy:

IF __CPU_GBZ80__ || __CPU_INTEL__
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

   jp asm_bcopy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bcopy
defc _bcopy = bcopy
ENDIF


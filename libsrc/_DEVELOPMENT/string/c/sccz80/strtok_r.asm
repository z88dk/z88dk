
; char *strtok_r(char * restrict s, const char * restrict sep, char ** restrict lasts)

SECTION code_clib
SECTION code_string

PUBLIC strtok_r

EXTERN asm_strtok_r

strtok_r:
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
   call asm_strtok_r
   ld d,h
   ld e,l
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
   jp asm_strtok_r
ENDIF
   

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtok_r
defc _strtok_r = strtok_r
ENDIF


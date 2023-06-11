
; int strncasecmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncasecmp

EXTERN asm_strncasecmp

strncasecmp:
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
   ld l,e
   ld e,a
   ld a,d
   ld d,h
   ld h,a
   call  asm_strncasecmp
   ld d,h
   ld e,l
   ret
ELSE
   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af

 IF __CLASSIC
  IF !__CPU_INTEL__ 
   push ix
  ENDIF
   call  asm_strncasecmp
  IF !__CPU_INTEL__ 
   pop  ix
  ENDIF
   ret
 ELSE
   jp asm_strncasecmp
 ENDIF
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncasecmp
defc _strncasecmp = strncasecmp
ENDIF


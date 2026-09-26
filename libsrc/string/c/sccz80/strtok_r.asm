
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


; Clang bridge for Classic
; Clang bridge for Classic (llvmz80 register ABI).
; __ZPROTO3(strtok_r, s, delim, lasts) -> ___strtok_r(lasts, delim, s):
;   HL=lasts (char**), DE=delim, [SP]=s (callee-cleaned by ret).
; asm_strtok_r enter: DE=sep, HL=s, BC=lasts (char**).
IF __CLASSIC
PUBLIC ___strtok_r
___strtok_r:
   ld c,l
   ld b,h                   ; BC = lasts (char **)
   pop hl                   ; HL = return address
   ex (sp),hl               ; HL = s, [SP] = return address
   ; DE = delim unchanged
   call asm_strtok_r        ; enter DE=delim, HL=s, BC=lasts; exit HL=token or 0
   ex de,hl                 ; DE = result ptr (C return value)
   ret
ENDIF


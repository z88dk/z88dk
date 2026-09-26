
; char *strnchr(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

PUBLIC strnchr

EXTERN asm_strnchr

strnchr:
IF __CPU_GBZ80__ | __CPU_INTEL__
   ld hl,sp+2
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl+)
   ld h,(hl)
   ld l,a
   call asm_strnchr
   ld d,h
   ld e,l
   ret
ELSE

   pop af
   pop de
   pop bc
   pop hl

   push hl
   push bc
   push de
   push af
   jp asm_strnchr
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnchr
defc _strnchr = strnchr
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strnchr
defc ___strnchr = strnchr
ENDIF


; strnchar(s, n, c) is a z88dk-extension alias for strnchr(s, n, c).
; __ZPROTO3 generates ___strnchar(c, n, s) -- fully reversed register ABI:
;   HL = c (int, low byte used), DE = n (size_t), stack = [ret][s]
; asm_strnchr wants: HL = s, E = c, BC = n
IF __CLASSIC
PUBLIC _strnchar               ; sccz80/sdcc: same stack layout as strnchr
defc _strnchar = strnchr

PUBLIC ___strnchar             ; llvmz80 clang: register-ABI bridge
___strnchar:
   ld a,l                     ; a = c (low byte)
   pop bc                     ; bc = ret_addr
   pop hl                     ; hl = s (3rd arg from stack)
   push bc                    ; restore ret_addr
   ld b,d                     ; bc = n (from DE)
   ld c,e
   ld e,a                     ; e = c
   call asm_strnchr
   ex de,hl                   ; DE = result (clang reads return in DE)
   ret
ENDIF


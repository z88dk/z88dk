
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t strxfrm(char * restrict s1, const char * restrict s2, size_t n)
;
; Transform string s2 according to current locale's char to
; ordinal mapping and write the result into s1.  No more than
; n chars are written to s1, including the terminal 0 byte.
;
; If (s1 == NULL) && (n == 0) the function runs without writing
; the transformed string to s1.
;
; Returns strlen(resulting s1).
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strxfrm

EXTERN asm_strlen, error_zc, __lc_char_ordinal

asm_strxfrm:

   ; enter : de = char *s1 = dst
   ;         hl = char *s2 = src
   ;         bc = size_t n
   ;
   ; exit  : 
   ;         if s1 == 0:
   ;
   ;           hl = strlen of would-be result
   ;           carry reset
   ;
   ;         else:
   ;
   ;           hl = strlen(resulting s1)
   ;           carry set if not all chars of s2 transformed
   ;
   ; uses  : af, bc, de, hl

   ld a,d
   or e
   jp Z, asm_strlen            ; if dst == 0, return strlen(src)

   ld a,b
   or c
   jp Z, error_zc              ; if n == 0, return 0 with carry set

   ; copy src to dst

   push hl                     ; save src
   
IF __CPU_8085__
   dec bc
ENDIF

loop:

   ld a,(hl)
   or a
   jp Z, end_s2

   dec bc

IF __CPU_8085__
   jp K,end_n
ELSE
   ld a,b
   or c
   jp Z, end_n
ENDIF

   push bc
   push hl
   push de

   ld a,(hl)
   call __lc_char_ordinal      ; assign ordinal to char

   pop de
   pop hl
   pop bc

   ld (de),a

   inc hl
   inc de
   jp loop

end_n:

   call end_s2

   scf
   ret

end_s2:

   ld (de),a                   ; terminate dst
   
   pop bc                      ; bc = src
IF __CPU_INTEL__ | __CPU_GBZ80__
IF __CPU_8085__
   sub hl,bc
ELSE
   ld  a,l
   sub c
   ld  l,a
   ld  a,h
   sbc b
   ld  h,a
ENDIF
ELSE
   sbc hl,bc                   ; hl = num chars written to s1
ENDIF

   or a
   ret

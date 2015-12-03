
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
   jp z, asm_strlen            ; if dst == 0, return strlen(src)
   
   ld a,b
   or c
   jp z, error_zc              ; if n == 0, return 0 with carry set
   
   ; copy src to dst
   
   push hl                     ; save src
   
loop:

   ld a,(hl)
   or a
   jr z, end_s2
   
   dec bc
   ld a,b
   or c
   jr z, end_n
   
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
   jr loop

end_n:

   call end_s2

   scf
   ret

end_s2:

   ld (de),a                   ; terminate dst
   
   pop de                      ; de = src
   sbc hl,de                   ; hl = num chars written to s1
   
   or a
   ret

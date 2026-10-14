
; ===============================================================
; Dec 2013 / Dec 2021 feilipu
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
; Returns the length of the transformed string, whether or not it fits in n.
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
   ;           hl = strlen of the transformed string
   ;           carry set if that length does not fit in n
   ;
   ; uses  : af, bc, de, hl

   ld a,d
   or e
   jp Z,asm_strlen             ; if dst == 0, return strlen(src)
   
   ld a,b
   or c
   jp Z,error_zc               ; if n == 0, return 0 with carry set

   ; copy src to dst

   push hl                     ; save src

   ; One byte of n is the terminating NUL. dec / inc b / inc c runs
   ; as many times as the count it is given, so n == 1 must stay out.
IF __CPU_8085__

   dec bc
   dec bc
   jp k,end_n                  ; n was 1
   inc b
   inc c

ELSE

   dec bc
   ld a,b
   or c
   jr Z,end_n                  ; n was 1

   dec bc
   inc b
   inc c

ENDIF

loop:
   ld a,(hl)
   or a
   jr Z,end_s2

   push bc
   push hl
   push de

   call __lc_char_ordinal      ; assign ordinal to char

   pop de
   pop hl
   pop bc

   ld (de),a

   inc hl
   inc de

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

end_n:

   ; Payload bytes are spent. A NUL here means the string fits in n.
   ld a,(hl)
   or a
   jr Z,end_s2

   xor a

seek_nul:
   cp (hl)
   jr Z,end_trunc

   inc hl
   jr seek_nul

end_trunc:
   ld (de),a                   ; terminate dst
   pop bc                      ; bc = src
   jp strlen_set

end_s2:
   ld (de),a                   ; terminate dst
   pop bc                      ; bc = src

IF __CPU_8080__ || __CPU_GBZ80__
   ld  a,l
   sub c
   ld  l,a
   ld  a,h
   sbc b
   ld  h,a
ELIF __CPU_8085__
   sub hl,bc
ELSE
   or a
   sbc hl,bc                   ; hl = strlen of the transformed string
ENDIF

   or a
   ret

strlen_set:

IF __CPU_8080__ || __CPU_GBZ80__
   ld  a,l
   sub c
   ld  l,a
   ld  a,h
   sbc b
   ld  h,a
ELIF __CPU_8085__
   sub hl,bc
ELSE
   or a
   sbc hl,bc
ENDIF

   scf
   ret

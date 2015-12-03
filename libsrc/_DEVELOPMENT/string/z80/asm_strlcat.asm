
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t strlcat(char * restrict s1, const char * restrict s2, size_t n)
;
; Append chars from s2 to s1 such that the total length of the resulting s1
; is maximum n chars including terminating NUL.
;
; s1 is unaltered if n < strlen(s1).
;
; Return strlen(s1) + strlen(s2).
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strlcat

asm_strlcat:

   ; enter : hl = char *s1 = dst
   ;         de = char *s2 = src
   ;         bc = size_t n
   
   ; exit  : hl = strlen(s1) + strlen(s2)
   ;         bc = char *s1
   ;         carry set if complete strlcat not possible
   ;
   ; uses  : af, bc, de, hl

   push hl                     ; save s1 to compute strlen(s1) later
   
   ld a,b                      ; catch degenerate case where n == 0
   or c
   jr z, szexceeded0

   xor a                       ; find end of string s1
   cpir
   
   dec hl                      ; hl parked on NUL and bc decr by one extra for the NUL
   jp po, szexceeded0          ; oops, size exceeded within string s1
   
   ; append to string s1 with chars from string s2
   
   ex de,hl                    ; de = s1, hl = s2

cpyloop:

   cp (hl)
   jr z, success
   
   ldi
   jp pe, cpyloop
   
   ; incomplete appending of string src
   
   xor a
   ld (de),a                   ; terminate string s1

szexceeded1:

   ; de = end of char *s1 (pointing at NUL)
   ; hl = somewhere in char *s2, next char to copy
   ; bc = 0
   ;  a = 0
   ; carry reset
   ; stack = char *s1

   push hl                     ; save current position in s2 to compute strlens later   

   cpir
   dec hl                      ; hl = end of char *s2 (pointing at NUL)
   
   pop bc
   sbc hl,bc
   ex de,hl                    ; de = strlen(s2 remnant)
   
   pop bc
   sbc hl,bc                   ; hl = strlen(result s1)
   
   add hl,de                   ; return strlen(s1)+strlen(s2)
   scf                         ; not enough space
   
   ret

szexceeded0:
   
   ; hl = nth char in s1
   ; de = char *s2
   ; bc = 0
   ;  a = 0
   ; carry reset
   ; stack = char *s1

   cpir
   dec hl                      ; hl = end of char *s1 (pointing at NUL)
   
   ld c,a
   ld b,a
   ex de,hl
   jr szexceeded1

success:

   ex de,hl
   ld (hl),a                   ; terminate s1 with NUL

   ; hl = end of char *s1 (pointing at NUL)
   ; carry flag reset
   ; stack = char *s1

   pop bc
   sbc hl,bc                   ; hl = strlen(final s1)
   ret

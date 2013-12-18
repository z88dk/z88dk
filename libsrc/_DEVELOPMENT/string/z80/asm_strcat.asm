
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strcat(char * restrict s1, const char * restrict s2)
;
; Append string s2 to the end of string s1, return s1.
;
; ===============================================================

XLIB asm_strcat

LIB __str_locate_nul

asm_strcat:
   
   ; enter : hl = char *s2 = src
   ;         de = char *s1 = dst
   ;
   ; exit  : hl = char *s1 = dst
   ;         de = ptr in s1 to terminating 0
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save dst

   ex de,hl
   call __str_locate_nul
   ex de,hl
   
loop:                          ; append s2 to s1

   ld a,(hl)
   ldi
   
   or a
   jp nz, loop
   
   pop hl                      ; hl = dst
   
   dec de
   ret

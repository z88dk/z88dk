
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t strlcpy(char * restrict s1, const char * restrict s2, size_t n)
;
; Copy at most n bytes from s2 to s1, including NUL.
; s1 is always terminated with NUL.
;
; Return the length of s2, the source string.
;
; Note if n == 0, s1 is not modified which means no NUL is written.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strlcpy

asm_strlcpy:

   ; enter : hl = char *s2 = src
   ;         de = char *s1 = dst
   ;         bc = size_t n
   ;
   ; exit:   de = ptr to NUL in dst
   ;         bc = char *s2 = src
   ;         hl = strlen(s2)
   ;         carry set if not enough space for complete copy
   ;
   ; uses:   af, bc, de, hl
   
   push hl                     ; save src to compute strlen later
   
   ld a,b
   or c
   jr z, szexceeded1
   
   xor a
   
cpyloop:

   cp (hl)                     ; end of src ?
   jr z, done
   
   ldi                         ; copy src byte to dst
   jp pe, cpyloop

szexceeded0:

   ; need to replace last char copied with a NUL
   
   dec de
   xor a
   ld (de),a
   
szexceeded1:

   ;  a = 0
   ; bc = 0
   ; hl = ptr in src
   ; de = ptr to NUL in dst
   ; carry reset
   ; stack = char *src
   
   cpir                        ; find end of src
   dec hl
   
   pop bc
   sbc hl,bc
   
   scf
   ret

done:

   ld (de),a                   ; terminate dst
   
   ; hl = ptr to NUL in src
   ; de = ptr to NUL in dst
   ; carry reset
   ; stack = char *src
   
   pop bc                      ; bc = char *src
   sbc hl,bc                   ; hl = strlen(s2)
   ret


; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *stpncpy(char * restrict s1, const char * restrict s2, size_t n)
;
; Copy at most n chars from string s2 to string s1, return address
; of first NUL char written to s1 or &s1[n] if no NUL is written.
;
; If strlen(s2) < n, s1 is padded with 0 bytes such that n
; chars are always written to s1.
;
; Note that s1 will not be 0 terminated if strlen(s2) >= n.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_stpncpy

asm_stpncpy:

   ; enter : de = char *s1 = dst
   ;         hl = char *s2 = src
   ;         bc = size_t n
   ;
   ; exit  : hl = address in s1 of first NUL written or &s1[n

   ;         bc = 0
   ;         z flag set if NUL was written to s1
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   jr z, exit
      
   ; copy src to dst
   
   xor a
   
loop:

   cp (hl)
   ldi
   jp po, done                 ; reached max number of chars
   jr nz, loop
   
   ; now pad with zeroes
   
   ld l,e
   ld h,d
   dec hl

   push hl                    ; save addr of first NUL in s1
   ldir
   pop hl
   
   ret

done:

   jr nz, exit                ; if last char was not NUL
   dec de                     ; move back to NUL

exit:

   ex de,hl
   ret

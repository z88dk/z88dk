
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t strrcspn(const char *str, const char *cset)
;
; The reverse of strcspn()
;
; Returns the number of leading chars in the input string up to
; and including the last occurrence of a char in cset.
;
; If none of the chars of str are in cset, returns 0.
;
; If cset is empty, returns strlen(str).
;
; Example:
;
; char *s = "Sentence! Part of a";
; int pos;
;
; // search from end of s for the first char in "!.?"
; pos = strrspn(s, "!.?");  // returns 9
;
; // delineate sentence by overwriting punctuation
; s[pos] = '\0';
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strrcspn

EXTERN __str_locate_nul, l_neg_bc, asm_strchr, error_zc

asm_strrcspn:

   ; enter : de = char *cset = matching set
   ;         hl = char *str = string
   ;
   ; exit  : hl = position of last char of str in cset
   ;         bc = char *str = string
   ;         de = char *cset = matching set
   ;
   ;         carry set if str contains no chars from cset
   ;
   ; uses  : af, bc, hl

   push hl                     ; save str

   call __str_locate_nul       ; hl points at terminating 0 in str
   call l_neg_bc               ; bc = strlen(str) + 1
   
   ld a,(de)
   or a
   jr z, empty_cset

loop:

   dec bc                      ; position of next char in str
   
   ld a,b
   or c
   jr z, none_in_cset

   dec hl                      ; & next char in str to check

   push bc
   push hl
   
   ; see if current char from string is in cset
   
   ld c,(hl)
   
   ld l,e
   ld h,d
   
   call asm_strchr             ; carry reset if in cset
   
   pop hl
   pop bc
   
   jr c, loop                  ; loop if char not in cset

in_cset:

   ld l,c
   ld h,b                      ; hl = char position

   pop bc                      ; bc = char *str
   ret

none_in_cset:

   pop bc                      ; bc = char *str
   jp error_zc

empty_cset:

   ld l,c
   ld h,b
   dec hl                      ; hl = strlen(str)
   
   pop bc                      ; bc = char *str
   scf
   ret

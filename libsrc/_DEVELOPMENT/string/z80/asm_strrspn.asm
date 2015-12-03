
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t strrspn(const char *str, const char *cset)
;
; The reverse of strspn()
;
; Returns the number of leading chars in the input string up to
; and including the last occurrence of a char not in cset.
;
; If all chars of str are in cset, returns 0.
;
; If cset is empty, returns strlen(str).
;
; Example:
;
; char *s = "abcdee";
; int pos;
;
; // search from the end of s for the first char not in "e"
; pos = strrspn(s, "e");  // returns 4 = num leading chars not in "e"
;
; // remove the last two Es from s by truncating s
; s[pos] = '\0';
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strrspn

EXTERN __str_locate_nul, l_neg_bc, asm_strchr, error_znc

asm_strrspn:

   ; enter : de = char *cset = matching set
   ;         hl = char *str = string
   ;
   ; exit  : hl = position of last char in str not in cset
   ;         bc = char *str = string
   ;
   ;         carry reset if all of str contains chars only from cset
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
   jr z, all_in_cset

   dec hl                      ; & next char in str to check

   push bc
   push hl
   
   ; see if current char from string is in cset
   
   ld c,(hl)
   
   ld l,e
   ld h,d                      ; hl = cset
   
   call asm_strchr             ; carry reset if in cset
   
   pop hl
   pop bc
   
   jr nc, loop                 ; loop if char in cset

not_in_cset:

   ld l,c
   ld h,b                      ; hl = char position

   pop bc                      ; bc = char *str
   ret

all_in_cset:

   pop bc                      ; bc = char *str
   jp error_znc

empty_cset:

   ld l,c
   ld h,b
   dec hl                      ; hl = strlen(str)
   
   pop bc                      ; bc = char *str
   ret

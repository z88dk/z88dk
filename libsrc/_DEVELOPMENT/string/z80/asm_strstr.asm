
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strstr(const char *s1, const char *s2)
;
; Return ptr in s1 to first occurrence of substring s2.
; If s2 has zero length, s1 is returned.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strstr

EXTERN error_zc

asm_strstr:

   ; enter : de = char *s1 = string
   ;         hl = char *s2 = substring
   ;
   ; exit  : de = char *s2 = substring
   ;
   ;         found
   ;
   ;           carry reset
   ;           hl = ptr in s1 to substring s2
   ;
   ;         not found
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, de, hl

   ld a,(hl)
   or a
   jr z, empty_substring
      
match_1:

   ; try to locate first char of substring in s1

   ld a,(de)                   ; a = *string
   cp (hl)
   jr z, match_rest            ; string char matches first substring char
   
   inc de
   
   or a                        ; end of string reached?
   jr nz, match_1

not_found:

   ex de,hl                    ; de = char *s2 = substring
   jp error_zc

match_rest:

   push de                     ; save s1 = string
   push hl                     ; save s2 = substring
   ex de,hl
   
   ; de = char *s2 = substring
   ; hl = char *s1 = string
   
loop:

   inc de
   inc hl
   
   ld a,(de)                   ; a = *substring
   or a
   jr z, match_found
   
   cp (hl)
   jr z, loop                  ; char matches so still hope

no_match:

   ld a,(hl)                   ; a = mismatch char in string
   
   pop hl                      ; hl = char *s2 = substring
   pop de                      ; de = char *s1 = string
   inc de
   
   or a                        ; if first mismatch occurred at end of string,
   jr nz, match_1              ; substring cannot fit so abandon early

   jr not_found

match_found:

   pop de                      ; de = char *s2 = substring
   pop hl                      ; hl = ptr to match in s1
   ret

empty_substring:

   ex de,hl
   ret

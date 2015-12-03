
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)
;
; Return ptr in big to first occurrence of substring little.
;
; If little_len = 0, returns big (differs from macox but
; consistent with strstr).
;
; If big_len == 0 or big_len < little_len or substring little
; is not found in big, returns NULL.
; 
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_memmem

EXTERN error_zc

asm_memmem:

   ; enter : ix = void *big (search string)
   ;         de = void *little (substring)
   ;         hl = big_len
   ;         bc = little_len
   ;
   ; exit  : de = void *little (substring)
   ;
   ;         substring found
   ;
   ;            carry reset
   ;            hl = ptr in big to matched substring
   ;
   ;         substring not found
   ;
   ;            carry set
   ;            hl = 0
   ;
   ; uses  : af, bc, hl, ix

   or a   
   sbc hl,bc
   jp c, error_zc              ; if big_len < little_len, not found
   inc hl                      ; hl = num positions in big to check
   
   ld a,b
   or c                        ; little_len == 0? ....
   dec bc                      ; bc = little_len - 1

   push ix                     ; save big
   
   push bc
   pop ix                      ; ix = little_len - 1
   
   ld c,l
   ld b,h                      ; bc = num positions to check

   pop hl                      ; hl = big
   
   ret z                       ; .... little_len == 0 means match
   
search_loop:

   ; hl = big
   ; de = little
   ; bc = num positions to check
   ; ix = little_len - 1

   ld a,(de)                   ; a = first little char
   cpir                        ; look for little char in big
   jp nz, error_zc             ; not found

   push hl
   push bc
   push de

   ; hl = big (2nd char of substring match)
   ; de = little
   ; ix = little_len - 1
   ; stack = big (2nd char of substring match), num positions to check, little

   push ix
   pop bc

   ld a,b
   or c
   jr z, found

match_substring:

   inc de
   ld a,(de)
   
   cpi
   jr nz, no_match
   
   jp pe, match_substring

found:

   pop de
   pop bc
   pop hl
   
   dec hl
   ret

no_match:

   pop de
   pop bc
   pop hl
   
   ; hl = big (next char to examine)
   ; de = little
   ; bc = num positions to check
   ; ix = little_len - 1
   
   ld a,b
   or c
   jr nz, search_loop

not_found:

   jp error_zc

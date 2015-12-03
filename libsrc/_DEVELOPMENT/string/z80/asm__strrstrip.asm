
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *_strrstrip(const char *s)
;
; Return ptr to first whitespace char of the trailing whitespace
; chars in s.
;
; If s consists entirely of whitespace then s is returned.
;
; See also strrstrip() that modifies s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm__strrstrip

EXTERN asm_strlen, asm_isspace

asm__strrstrip:

   ; enter : hl = char *s
   ;
   ; exit  : hl = ptr to first ws char of trailing ws chars in s
   ;         de = char *s
   ;         carry reset if s is entirely whitespace
   ;
   ; uses  : af, bc, de, hl

   ld e,l
   ld d,h                      ; de = char *s

   ; find strlen(s) and terminating NUL

   call asm_strlen
   jr z, exit                  ; if strlen(s) == 0
   
   ld c,l
   ld b,h                      ; bc = strlen(s)
     
   add hl,de                   ; hl = s + strlen(s)
   dec hl                      ; hl points at last char in s
   
loop:

   ld a,(hl)
   call asm_isspace
   jr c, not_ws
   
   cpd                         ; hl--, bc--
   jp pe, loop
   
all_ws:
exit:

   ld l,e
   ld h,d
   ret

not_ws:

   inc hl                      ; past non-ws char
   ret


; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strsep(char ** restrict stringp, const char * restrict delim)
;
; BSD alternative to strtok().
;
; Similar to strtok_r() with two key differences:
;
; (1) stringp is used to store state between calls and to
;     communicate a new string to tokenize
;
; (2) strsep() will not skip over leading delim chars when
;     tokenizing the string.  This means strsep() could return
;     sequences of empty strings as multiple delim chars are
;     encountered in sequence.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strsep

EXTERN asm_strpbrk

asm_strsep:

   ; enter : de = char *delim
   ;         bc = char **stringp
   ;
   ; exit  : de = char *delim
   ;         bc = char **stringp
   ;
   ;         token found
   ;
   ;           carry set
   ;           hl = char *token
   ;
   ;         no more tokens
   ;
   ;           carry reset
   ;           hl = 0
   ;
   ; uses  : af, hl
   
   ld a,(bc)
   ld l,a
   inc bc
   ld a,(bc)
   ld h,a                      ; hl = char *s
   
   or l                        ; s == NULL?
   jr z, notoken
   
have_string:

   ; find end of token by searching for a delim char
   ;
   ; hl = char *s
   ; de = char *delims
   ; bc = char **string_ptr + 1b
   
   push hl                     ; save start of token
   push bc                     ; save char **string_ptr + 1b
   
   call asm_strpbrk            ; hl = ptr to delim char
   jr c, token_toend           ; if token extends to end of string (hl=0)
   
   ld (hl),0                   ; terminate token by overwriting delim char
   inc hl                      ; tokenize from here next time

token_toend:

   ; hl = char *s (where to tokenize from next time)
   ; de = char *delims
   ; stack = char *s (start of token), char **string_ptr + 1
   
   pop bc
   
   ld a,h                      ; write next token position into string_ptr
   ld (bc),a
   dec bc
   ld a,l
   ld (bc),a
   
   pop hl                      ; hl = start of token
   scf
   ret

notoken:

   dec bc
   ret


; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strtok_r(char * restrict s, const char * restrict sep, char ** restrict lasts)
;
; Re-entrant version of strtok() using lasts to store state
; betweem calls.
;
; If s != NULL, s becomes the new string to tokenize.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strtok_r

EXTERN asm_strspn, asm_strpbrk

asm_strtok_r:

   ; enter : de = char *sep = delimiters
   ;         hl = char *s = string to tokenize
   ;         bc = char **lasts (state)
   ;
   ; exit  : de = char *swp = delimiters
   ;         bc = char **lasts (state)
   ;
   ;         found
   ;
   ;           carry set
   ;           hl = ptr to token
   ;
   ;         not found
   ;
   ;           carry reset
   ;           hl = 0
   ;
   ; uses  : af, hl

   ld a,h                      ; s == NULL?
   or l
   jr nz, have_string
   
   ld a,(bc)
   ld l,a
   inc bc
   ld a,(bc)
   dec bc
   ld h,a                      ; hl = saved position
      
   or l                        ; is last position NULL?
   ret z

have_string:

   push bc                     ; save state

   ; first skip over any leading delim chars
   ;
   ; de = char *s2 = delims
   ; hl = char *s1 = string
   ; stack = state

   call asm_strspn             ; hl = number of leading delim chars, bc = char *s1 = string
   jr c, no_token              ; if string only contains delim chars
   
   add hl,bc                   ; hl = start of token after delim chars
   
   ; next find end of token by searching for a delim char
   ;
   ; hl = char *s1 = start of token
   ; de = char *s2 = delims
   ; stack = state
   
   pop bc
   push hl                     ; save start of token
   push bc                     ; save state
   
   call asm_strpbrk            ; hl = ptr to delim char in string
   jr c, token_toend           ; if token extends to end of string (hl=0)
   
   ld (hl),0                   ; terminate token with NUL
   inc hl                      ; start point for next token
   
token_toend:

   pop bc                      ; bc = state = char **lasts
   
   ld a,l                      ; save next start position
   ld (bc),a
   inc bc
   ld a,h
   ld (bc),a
   dec bc

   pop hl                      ; hl = start of token
   scf
   ret

no_token:

   pop bc                      ; bc = state = char **lasts
   
   xor a                       ; next start position = NULL
   ld (bc),a
   inc bc
   ld (bc),a
   dec bc
   
   ld l,a
   ld h,a
   ret


; ===============================================================
; Jan 2015
; ===============================================================
; 
; char* strset(char *s, int c)
;
; Fill the string with char c.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strset

EXTERN l_ret

asm_strset:

   ; enter : hl = char *s
   ;          e = int c
   ;
   ; exit  : hl = char *s
   ;
   ; uses  : af
   
   push hl
   xor a
   
loop:

   cp (hl)
   jp z, l_ret - 1
   
   ld (hl),e
   inc hl
   
   jr loop

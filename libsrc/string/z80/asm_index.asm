
; BSD
; char *index(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC asm_index

EXTERN asm_strchr

defc asm_index = asm_strchr

   ; enter :  c = char c
   ;         hl = char *s
   ;
   ; exit  :  c = char c
   ;
   ;         found
   ;
   ;           carry reset
   ;           hl = ptr to c
   ;
   ;         not found
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, hl


; BSD
; char *rindex(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC asm_rindex

EXTERN asm_strrchr

defc asm_rindex = asm_strrchr

   ; enter :  c = char c
   ;         hl = char *s
   ;
   ; exit  : 
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
   ; uses  : af, bc, e, hl

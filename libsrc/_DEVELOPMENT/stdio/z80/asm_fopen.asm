
; ===============================================================
; Apr 2014
; ===============================================================
; 
; FILE *fopen(const char *filename, const char *mode);
;
; Open a file.
;
; ===============================================================

SECTION seg_code_stdio

PUBLIC asm_fopen

EXTERN asm_fopen_unlocked

defc asm_fopen = asm_fopen_unlocked

   ; enter : de = char *mode
   ;         hl = char *filename
   ;
   ; exit  : success
   ;
   ;            hl = FILE *
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : all

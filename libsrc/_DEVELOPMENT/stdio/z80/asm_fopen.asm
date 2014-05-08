
; ===============================================================
; Apr 2014
; ===============================================================
; 
; FILE *fopen(const char *filename, const char *mode);
;
; Open a file.
;
; ===============================================================

PUBLIC asm_fopen

EXTERN asm_fopen_unlocked

asm_fopen:

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
   ; uses  : all except ix

   jp asm_fopen_unlocked

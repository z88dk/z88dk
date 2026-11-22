
; ===============================================================
; October 2014
; ===============================================================
; 
; int open(const char *path, int oflag, ...)
;
; Open a file.
;
; ===============================================================

SECTION code_clib
SECTION code_fcntl

PUBLIC asm_open

EXTERN asm_vopen, __stdio_varg_2, __stdio_nextarg_bc

asm_open:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
   ;
   ; exit  : 
   ;
   ; uses  : all except iy
   
   call __stdio_varg_2         ; de = path
   call __stdio_nextarg_bc     ; bc = oflag
   
   jp asm_vopen


; ===============================================================
; October 2014
; ===============================================================
; 
; int creat(const char *path, mode_t mode)
;
; Equivalent to open(path, O_WRONLY|O_CREAT|O_TRUNC, mode)
;
; ===============================================================

SECTION code_clib
SECTION code_fcntl

PUBLIC asm_creat

EXTERN asm0_vopen, l_inc_sp

asm_creat:

   ; enter : de = char *path
   ;         bc = int mode
   ;
   ; exit  : success
   ;
   ;            hl = int fd
   ;            de = FDSTRUCT *
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except iy

   push bc                     ; save mode
   
   ld hl,0
   add hl,sp                   ; hl = void *arg
   
   ld bc,$52                   ; O_WRONLY|O_CREAT|O_TRUNC
   call asm0_vopen
   
   jp l_inc_sp - 2             ; pop item from stack

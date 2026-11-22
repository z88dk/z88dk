
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

EXTERN asm0_vopen

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
   ; uses  : all except ix, iy

   push ix
   push bc                     ; save mode

   ld hl,0
   add hl,sp                   ; hl = void *arg

   ld bc,$52                   ; O_WRONLY|O_CREAT|O_TRUNC
   call asm0_vopen

   pop bc                      ; discard mode
   pop ix
   ret

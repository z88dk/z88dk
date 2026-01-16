
; ===============================================================
; October 2014
; ===============================================================
; 
; int ioctl(int fildes, int request, ...)
;
; Sends configuration messages to the underlying driver.
;
; ===============================================================

SECTION code_clib
SECTION code_fcntl

PUBLIC asm_ioctl

EXTERN asm_vioctl, __stdio_varg_2, __stdio_nextarg_bc

asm_ioctl:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
   ;
   ; exit  : success
   ;
   ;            ix = FDSTRUCT* corresponding to receiving device
   ;            hl = return value
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix

   call __stdio_varg_2         ; de = fd
   call __stdio_nextarg_bc     ; bc = request
   
   ex de,hl
   jp asm_vioctl

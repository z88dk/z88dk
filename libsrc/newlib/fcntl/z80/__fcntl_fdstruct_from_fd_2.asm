
SECTION code_clib
SECTION code_fcntl

PUBLIC __fcntl_fdstruct_from_fd_2

EXTERN __fcntl_fdstruct_from_fd_1, error_ebdfd_zc

__fcntl_fdstruct_from_fd_2:

   ; return FDSTRUCT* at index fd
   ;
   ; enter : hl = int fd
   ;
   ; exit  : success
   ;
   ;           ix = de = FDSTRUCT *
   ;           hl = & fdtbl[fd] + 1b
   ;           carry reset
   ;
   ;         fail
   ;
   ;           hl = 0
   ;           carry set, errno = EBDFD
   ;
   ; uses  : af, de, hl, ix

   call __fcntl_fdstruct_from_fd_1
   
   ret c                       ; if fd out of range
   jp z, error_ebdfd_zc        ; if fd vacant
   
   push de
   pop ix                      ; ix = FDSTRUCT *
   
   ret

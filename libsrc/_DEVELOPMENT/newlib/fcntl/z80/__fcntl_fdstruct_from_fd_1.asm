
SECTION code_clib
SECTION code_fcntl

PUBLIC __fcntl_fdstruct_from_fd_1

EXTERN error_ebdfd_zc
EXTERN __fcntl_fdtbl, __fcntl_fdtbl_size

__fcntl_fdstruct_from_fd_1:

   ; return fdstruct* at index fd
   ;
   ; enter : hl = int fd
   ;
   ; exit  : success
   ;
   ;           de = FDSTRUCT *
   ;           hl = & fdtbl[fd] + 1b
   ;           z flag set if de == 0 (index vacant)
   ;           carry reset
   ;
   ;         fail if fd out of range
   ;
   ;           hl = 0
   ;           carry set, errno = EBDFD
   ;
   ; uses  : af, de, hl
   
   ld a,h
   or a
   jp nz, error_ebdfd_zc
   
   ld a,l
   sub __fcntl_fdtbl_size
   jp nc, error_ebdfd_zc

   add hl,hl
   ld de,__fcntl_fdtbl
   add hl,de
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ld a,d
   or e
   
   ret

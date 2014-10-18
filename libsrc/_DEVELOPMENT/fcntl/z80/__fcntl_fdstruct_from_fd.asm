
SECTION seg_code_fcntl

PUBLIC __fcntl_fdstruct_from_fd
PUBLIC __0_fcntl_fdstruct_from_fd

EXTERN error_ebdfd_zc
EXTERN __fcntl_fdtbl, __fcntl_fdtbl_size

__fcntl_fdstruct_from_fd:

   ; return fdstruct* at index fd
   ;
   ; enter : hl = int fd
   ;
   ; exit  : success
   ;
   ;           ix = de = FDSTRUCT *
   ;           carry reset
   ;
   ;         fail
   ;
   ;           hl = 0
   ;           carry set, errno = EBDFD
   ;
   ; uses  : af, de, hl, ix
   
   ld a,h
   or a
   jp nz, error_ebdfd_zc
   
   ld a,l
   sub __fcntl_fdtbl_size
   jp nc, error_ebdfd_zc

__0_fcntl_fdstruct_from_fd:

   add hl,hl
   ld de,__fcntl_fdtbl
   add hl,de
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ld ixl,e
   ld ixh,d
   
   ld a,d
   or e
   
   ret nz
   jp error_ebdfd_zc


SECTION code_clib
SECTION code_fcntl

PUBLIC __fcntl_fd_from_fdstruct

EXTERN error_ebdfd_mc
EXTERN __fcntl_fdtbl, __fcntl_fdtbl_size

__fcntl_fd_from_fdstruct:

   ; search for fdstruct in fdtbl and return corresponding fd
   ;
   ; enter : de = FDSTRUCT *
   ;
   ; exit  : success
   ;
   ;            b = fdtbl_size - fd
   ;           hl = & fdtbl[fd] + 1b
   ;           carry reset
   ;
   ;         fail if not found
   ;
   ;           hl = -1
   ;           carry set, errno = EBDFD
   ;
   ; uses  : af, b, hl
   
   ld b,__fcntl_fdtbl_size
   ld hl,__fcntl_fdtbl

loop_0:

   ld a,e

loop_1:

   cp (hl)
   inc hl
   
   jr z, possible_match
   
   inc hl
   djnz loop_1
   
   jp error_ebdfd_mc

possible_match:

   ld a,d
   cp (hl)
   
   ret z                       ; if match
   
   inc hl
   djnz loop_0
   
   jp error_ebdfd_mc

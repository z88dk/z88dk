
SECTION code_clib
SECTION code_fcntl

PUBLIC __fcntl_first_available_fd

EXTERN __fcntl_fdtbl, __fcntl_fdtbl_size

__fcntl_first_available_fd:

   ; locate first available fd slot
   ;
   ; exit : success
   ;
   ;           b = fdtbl_size - fd
   ;          hl = & fdtbl[fd] + 1b
   ;          z flag set
   ;
   ;        fail
   ;
   ;          nz flag set
   ;
   ; uses : af, b, hl
   
   ld b,__fcntl_fdtbl_size
   ld hl,__fcntl_fdtbl

loop:

   ld a,(hl)
   inc hl
   
   or (hl)
   ret z                       ; if empty slot found
   
   inc hl
   djnz loop
   
   ret                         ; slot not found

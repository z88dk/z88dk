; FILE __CALLEE__ *fdopen_callee(int fd, char *mode)
; 06.2008 aralbrec

XLIB fdopen_callee
XDEF ASMDISP_FDOPEN_CALLEE

LIB stdio_parseperm, stdio_malloc, fd_fdtblindex, stdio_addfiletolist
LIB stdio_error_ebadf_zc, stdio_error_einval_zc, stdio_error_enomem_zc

INCLUDE "stdio.def"

.fdopen_callee

   pop hl
   pop de
   ex (sp),hl

.asmentry

   ; enter :  l = int fd
   ;         de = char *mode
   ; exit  : hl = FILE * and carry reset for success
   ;         hl = 0 and carry set for fail
   
   ld a,l
   cp MAXFILES
   jp nc, stdio_error_ebadf_zc

   call fd_fdtblindex
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = fdstruct *
   
   ld a,b
   or c
   jp z, stdio_error_ebadf_zc

   inc bc
   inc bc
   inc bc                      ; bc = & fdstruct.flags0
      
   ex de,hl                    ; hl = char *mode
   push bc
   call stdio_parseperm        ;  a = 0000 CIOA
   pop bc
   jp z, stdio_error_einval_zc   ; mode string not understood
   
   and $07                     ; only interested in the input/output/append bits
   ld l,a                      ; l = desired r/w/a mode
   ld a,(bc)                   ; get r/w/a mode of fd
   and l
   cp l
   jp nz, stdio_error_einval_zc  ; file is not open for desired mode

   dec bc
   dec bc
   dec bc                      ; bc = fdstruct *
   
   ; okay to fdopen, now create the FILE struct
   
   push bc                     ; save fdstruct *
   push af                     ; a = 0000 0IOA
   ld bc,FILESTR_SZ            ; sizeof(FILE)
   call stdio_malloc
   jp nc, stdio_error_enomem_zc - 2
   
   ; hl = FILE * (offset -4)
   
   call stdio_addfiletolist    ; hl = FILE * (offset 0)
   pop af                      ; a = 0000 0IOA
   pop bc                      ; bc = fdstruct *

   ld e,l
   ld d,h
   ld (hl),195                 ; fill in the FILE struct
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   and $06                     ; clear A bit
   ld (hl),a
   
   ex de,hl
   ret

defc ASMDISP_FDOPEN_CALLEE = asmentry - fdopen_callee

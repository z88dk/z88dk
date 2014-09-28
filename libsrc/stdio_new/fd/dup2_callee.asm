; int __CALLEE__ dup2_callee(int fdsrc, int fddst)
; 07.2009 aralbrec

XLIB dup2_callee
XDEF ASMDISP_DUP2_CALLEE

LIB stdio_fdcommon1, stdio_getfdtblentry, stdio_getfdstruct
LIB close, stdio_dupcommon1, stdio_dupcommon2, stdio_error_ebadf_mc
XREF LIBDISP2_CLOSE

INCLUDE "../stdio.def"

; dup existing source fd into specific destination fd
; close any file open on destination fd

.dup2_callee

   pop hl
   pop bc
   ex (sp),hl

.asmentry

   ; 1. verify source fd is valid
   ;
   ; l = source fd
   ; c = destination fd
   
   ld b,l
   call stdio_dupcommon2       ; ix = source fdstruct
   jp c, stdio_error_ebadf_mc  ; problem with source fd

   ; 2. check if source fd == destination fd
   ;
   ;  b = source fd
   ;  c = destination fd
   ; ix = source fdstruct
   
   ld a,c
   cp b
   jr z, fdmatch
   
   ; 3. check destination fd is in range
   ;
   ;  a = c = destination fd
   ; ix = source fdstruct
   
   call stdio_getfdtblentry    ; hl = & stdio_fdtbl[dest fd]
   jp c, stdio_error_ebadf_mc
   
   ; 4. see if destination fd is an open file
   ;
   ;  c = destination fd
   ; hl = & stdio_fdtbl[dest fd]
   ; ix = source fdstruct
   
   push ix                     ; save source fdstruct
   call stdio_getfdstruct      ; ix = destination fdstruct
   
   ; 5. if destination fd holds an open file we need to close it
   ;
   ;  c = destination fd
   ; hl = & stdio_fdtbl[dest fd] + 1
   ; ix = destination fdstruct
   ; carry set if no open file
   ; stack = source fdstruct
   
   jr c, noclose
   
   push hl
   exx
   pop hl
   call close + LIBDISP2_CLOSE
   exx

.noclose

   ; 6. create dup in destination fd
   ;
   ;  c = destination fd
   ; hl = & stdio_fdtbl[dest fd] + 1
   ; stack = source fdstruct
   
   ld b,c                      ; b = destination fd
   pop ix                      ; ix = source fdstruct
   jp stdio_dupcommon1   
 
 .fdmatch
 
   ld l,a
   ld h,0
   ret
 
defc ASMDISP_DUP2_CALLEE = # asmentry - dup2_callee

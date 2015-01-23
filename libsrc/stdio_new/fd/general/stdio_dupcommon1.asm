; stdio_dupcommon1
; 07.2009 aralbrec

PUBLIC stdio_dupcommon1
EXTERN stdio_malloc, stdio_error_enomem_mc

INCLUDE "../../stdio.def"

; common code factored out of dup functions
; centralizes key steps for making dup fds
;
; enter : ix = source fdstruct *
;          b = destination fd
;         hl = MSB of fdtbl entry for dest fd
; exit  : b = hl = destination fd, de = dup fdstruct*, carry reset
;         hl = -1, carry set if error

.stdio_dupcommon1

   ; 1a. get memory for dup fdstruct
   ;
   ; ix = source fdstruct *
   ;  b = destination fd
   ; hl = MSB of fdtbl entry for dest fd

   exx
   
   ld bc,STDIO_SIZEOF_DUP
   call stdio_malloc           ; get memory for dup fdstruct
   jp nc, stdio_error_enomem_mc
   
   ; 1b. increase reference count in source fdstruct
   ; 
   ; ix = source fdstruct *
   ; hl = uninitialized dup fdstruct *
   ; exx = stuff
   
   inc (ix+4)
   
   ; 2. initialize dup fdstruct
   ;
   ; ix = source fdstruct *
   ; hl = uninitialized dup fdstruct *
   ; exx = stuff

   push hl                     ; save dup fdstruct *
   
   ld (hl),195                 ; JP instruction
   inc hl
   
   ld a,ixl
   ld (hl),a                   ; source fdstruct
   inc hl
   ld a,ixh
   ld (hl),a
   inc hl
   
   ld a,(ix+3)                 ; get source flags
   and $07
   or $80
   ld (hl),a                   ; copy to dup flags
   inc hl
   
   ld (hl),1                   ; reference count

   exx
   pop de
   
   ; 3. enter dup fdstruct into fdtbl
   ;
   ;  b = destination fd
   ; hl = MSB of fdtbl entry for dest fd
   ; de = dup fdstruct *

   ld (hl),d
   dec hl
   ld (hl),e
   
   ; 4. exit
   ;
   ;  b = destination fd
   ;  carry flag reset
   
   ld l,b
   ld h,0
   ret

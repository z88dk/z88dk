; int __FASTCALL__ fileno(FILE *stream)
; 07.2009 aralbrec

PUBLIC fileno
PUBLIC ASMDISP_FILENO

EXTERN stdio_descendchain, stdio_error_ebadf_mc, stdio_findfdstruct

INCLUDE "../stdio.def"

.fileno

   ; enter : hl = FILE *
   ; exit  : a = hl = fd, hl = & stdio_fdtbl[fd]+1 and carry reset for success
   ;         hl = -1 and carry set for fail
   ; uses  : af, bc, hl, ix

   push hl
   pop ix

.asmentry

   ; ix = fdstruct *

.loop

   call stdio_descendchain     ; ix = next file structure in stdio chain
   bit 3,(ix+3)                ; have we reached an fdstruct yet?
   jr nz, loop
   
   ; ix = first fdstruct* in chain

   call stdio_findfdstruct
   jp c, stdio_error_ebadf_mc
   
   ld a,STDIO_NUMFD
   sub b
   ld l,a
   ld h,0
   ret

defc ASMDISP_FILENO = # asmentry - fileno

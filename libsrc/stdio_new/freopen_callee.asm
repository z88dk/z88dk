; FILE __CALLEE__ *freopen_callee(char *filename, char *mode, FILE *stream)
; 06.2008 aralbrec

XLIB freopen_callee
XDEF ASMDISP_FREOPEN_CALLEE

LIB fopen_callee, close, fflush, l_jpix
XREF LIBDISP_FOPEN_CALLEE, LIBDISP_CLOSE

INCLUDE "stdio.def"

.freopen_callee

   pop af
   pop hl
   pop bc
   pop de
   push af

.asmentry

   ; enter : hl = FILE *stream
   ;         bc = char *mode
   ;         de = char *filename
   ; exit  : hl = FILE * and carry reset for success
   ;         hl = 0 and carry set for fail (stream will be closed and deallocated)

   ; 1. set up stack for fopen call later
   
   push de
   push hl
   push bc

   ; 2. flush the stream and deallocate high level buffers
   
   push hl
   call fflush
   
   ; ix = FILE *
   
   ld c,STDIO_MSG_FCLS
   call l_jpix
   pop hl

   ; 3. close FILE *stream
   ;
   ; hl = FILE *
   ; stack = ret addr, char *filename, FILE *stream, char *mode
   
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = fdstruct
   
   call close + LIBDISP_CLOSE

   ; 3. fopen using existing struct FILE
   ;
   ; stack = ret addr, char *filename, FILE *stream, char *mode

   pop hl
   jp fopen_callee + LIBDISP_FOPEN_CALLEE
   
defc ASMDISP_FREOPEN_CALLEE = asmentry - freopen_callee

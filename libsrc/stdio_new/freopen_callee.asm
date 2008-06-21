; FILE __CALLEE__ *freopen_callee(char *filename, char *mode, FILE *stream)
; 06.2008 aralbrec

XLIB freopen_callee
XDEF ASMDISP_FREOPEN_CALLEE

LIB fopen_callee, fclose
XREF LIBDISP_FOPEN_CALLEE, LIBDISP_FCLOSE

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

   ; 2. close FILE *stream
   ;
   ; hl = FILE *
   ; stack = ret addr, char *filename, FILE *stream, char *mode
   
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = fdstruct
   
   call fclose + LIBDISP_FCLOSE

   ; 3. fopen using existing struct FILE
   ;
   ; stack = ret addr, char *filename, FILE *stream, char *mode

   pop hl
   jp fopen_callee + LIBDISP_FOPEN_CALLEE
   
defc ASMDISP_FREOPEN_CALLEE = asmentry - freopen_callee

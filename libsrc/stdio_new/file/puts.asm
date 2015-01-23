; int __FASTCALL__ puts(const char *s)
; 06.2008 aralbrec

PUBLIC puts
EXTERN fputs_callee, l_jpix, stdio_error_mc, stdio_success_znc
EXTERN ASMDISP_FPUTS_CALLEE
EXTERN _stdout

INCLUDE "../stdio.def"

.puts

   ; put string and a '\n' to stdout
   ;
   ; enter : hl = char *s
   ; exit  : hl = 0 carry reset for success
   ;         hl = -1 carry set for fail
   ; uses  : af, bc, de, hl, ix

   ld ix,(_stdout)
   call fputs_callee + ASMDISP_FPUTS_CALLEE
   ret c
   
   ; ix = FILE *
   
   ld c,13
   ld a,STDIO_MSG_PUTC
   call l_jpix
   jp nc, stdio_success_znc
   jp stdio_error_mc

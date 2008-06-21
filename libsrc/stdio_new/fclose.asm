; int __FASTCALL__ fclose(FILE *stream)
; 06.2008 aralbrec

XLIB fclose
XDEF LIBDISP_fclose

LIB close, fileno, stdio_free
LIB stdio_success_znc
XREF LIBDISP_CLOSE, LIBDISP_FILENO

.fclose

   ; 1. get attached fdstruct and free memory associated with FILE
   ; 
   ; hl = FILE *

   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = fdstruct
   
   dec hl
   dec hl
   push de
   call stdio_free             ; free FILE
   pop hl
   
   ; 2. determine if fd struct has an entry in the fdtbl
   ;
   ; hl = fdstruct

.libentry

   push hl
   call fileno + LIBDISP_FILENO  ; l = fd
   pop de                      ; de = fdstruct
   jp nc, close                ; if there is an entry use close(fd)

   ; 3. close(fdstruct)
   ;
   ; de = fdstruct
   
   jp close + LIBDISP_CLOSE

defc LIBDISP_FCLOSE = libentry - fclose

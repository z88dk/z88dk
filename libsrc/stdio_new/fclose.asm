; int __FASTCALL__ fclose(FILE *stream)
; 06.2008 aralbrec

XLIB fclose

LIB close, fflush, stdio_free, stdio_rmfilefromlist
XREF LIBDISP_CLOSE

.fclose

   ; 1. flush the stream
   ;
   ; hl = FILE *

   push hl
   call fflush
   pop hl
   
   ; 2. get attached fdstruct and free memory associated with FILE
   ; 
   ; hl = FILE *

   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = fdstruct
   
   dec hl
   dec hl
   push de
   call stdio_rmfilefromlist   ; remove from open FILE list
   call stdio_free             ; free FILE
   pop de
   
   ; 3. close underlying fdstruct
   ;
   ; de = fdstruct

   jp close + LIBDISP_CLOSE

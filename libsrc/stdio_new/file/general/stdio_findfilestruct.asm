; stdio_findfilestruct
; 07.2009 aralbrec

PUBLIC stdio_findfilestruct

EXTERN stdio_findfdstruct
EXTERN _stdio_filetbl, LIBDISP_STDIO_FINDFDSTRUCT

; return address of table entry holding file struct address
;
; enter : ix = FILE *
; exit  : hl = & stdio_filetbl[FILEentry] + 1, carry reset
;         carry set if FILE* not in filetbl
; uses  : af, b, hl

INCLUDE "../../stdio.def"

.stdio_findfilestruct

   ld b,STDIO_NUMFILE + 3      ; include stdin / stdout / stderr in this search
   ld hl,_stdio_filetbl - 6
   
   jp stdio_findfdstruct + LIBDISP_STDIO_FINDFDSTRUCT  ; save a few bytes

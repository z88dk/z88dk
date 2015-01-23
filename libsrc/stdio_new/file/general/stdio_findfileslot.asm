; stdio_findfileslot
; 07.2009 aralbrec

PUBLIC stdio_findfileslot

EXTERN stdio_findfdslot
EXTERN _stdio_filetbl, LIBDISP_STDIO_FINDFDSLOT

INCLUDE "../../stdio.def"

.stdio_findfileslot

   ; find the first available slot in FILE tbl for a new FILE
   ;
   ; exit :  b = STDIO_NUMFILE - FILEslot
   ;        hl = MSB of filetbl entry
   ;        carry set if no available slot
   ; uses : af, b, hl

   ld b,STDIO_NUMFILE
   ld hl,_stdio_filetbl
   
   jp stdio_findfdslot + LIBDISP_STDIO_FINDFDSLOT  ; save a few bytes

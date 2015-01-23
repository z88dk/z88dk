; int __FASTCALL__ dup(int fd)
; 07.2009 aralbrec

PUBLIC dup

EXTERN stdio_fdcommon1, stdio_findfdslot, stdio_dupcommon1, stdio_dupcommon2
EXTERN stdio_error_ebadf_mc, stdio_error_enfile_mc

INCLUDE "../stdio.def"

; create a duplicate fd for an existing fd
; the duplicate will forward messages to the existing fd
;
; enter: l = fd to dup

.dup

   ; 1. look up source fdstruct *, verify it is okay
   ;
   ; l = source fd

   call stdio_dupcommon2       ; ix = source fdstruct *
   jp c, stdio_error_ebadf_mc  ; problem with source fd

   ; 2a. find first available fd slot for dup
   ;
   ; ix = source fdstruct *

   call stdio_findfdslot       ; find first available fd
   jp c, stdio_error_enfile_mc ; no slot available
   
   ; 2b. correct destination fd number
   ;
   ; ix = source fdstruct *
   ;  b = STDIO_NUMFD - fd (available fd)
   ; hl = MSB of fdtbl entry (available fd)

   ld a,STDIO_NUMFD
   sub b
   ld b,a

   jp stdio_dupcommon1
   
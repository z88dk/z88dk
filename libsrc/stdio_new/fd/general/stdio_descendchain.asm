; stdio_descendchain
; 07.2009 aralbrec

PUBLIC stdio_descendchain

; descend one level in the stdio chain
;
; enter : ix = a file structure (FILE* or FDSTRUCT*)
; exit  : ix = next file structure in the chain, carry set
;         carry reset if no next structure and ix unchanged
; uses  : af, c, ix

.stdio_descendchain

   ld a,(ix+3)                 ; flags
   and $c8                     ; keep dup, filter, file flags
   ret z                       ; this is a driver, no next file
   
   and $40                     ; is this a filter?
   jr z, not_filter

   ld a,(ix+6)
   ld c,(ix+7)
   
   jp done

.not_filter

   ld a,(ix+1)
   ld c,(ix+2)   

.done

   ld ixl,a
   ld ixh,c

   scf
   ret

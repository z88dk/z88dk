
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================
;
; void *fzx_buffer_partition(void *buf, uint len, uint width)
;
; Finds longest prefix string of buf that has pixel width less than
; or equal to "width".  Newline, \0, and AT indicator cause the
; iteration to stop.
;
; Returned pointer points at one char past the prefix.
; ie (return - buf) is the number of chars in the prefix string.
;
; ===============================================================

PUBLIC asm_fzx_buffer_partition

EXTERN __fzx_glyph_width, _fzx

asm_fzx_buffer_partition:

   ; enter : de = void *buf
   ;         bc = uint len
   ;         hl = allowed width in pixels
   ;
   ; exit  : hl = buf + prefixlen
   ;         ix = struct fzx_font *
   ;         bc = remaining len in buf
   ;
   ;         carry reset if stopped with room available
   ;         de = remaining width in pixels
   ;
   ;         carry set if width exceeded
   ;         de = - remaining width in pixels
   ;
   ; uses  : af, bc, de, hl, ix

   ld ix,(_fzx + 0)            ; ix = current font

loop_consume:

   ld a,b                      ; end of buffer?
   or c
   jr z, end_string
   
   ld a,(de)
   
   cp 13                       ; terminate at newline
   jr z, end_string
   
   cp 22                       ; terminate at AT sequence
   jr z, end_string

   push bc
   push hl
   
   call __fzx_glyph_width
   ld c,a
   ld b,0                      ; bc = char width
   
   pop hl
   sbc hl,bc                   ; is there room for the char?
   pop bc
   jr c, end_string
   
   dec bc
   inc de
   jr loop_consume

end_string:

   ex de,hl
   ret

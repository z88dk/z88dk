
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================
;
; char *fzx_string_partition(char *s, uint width)
;
; Finds longest prefix string of s that has pixel width less than
; or equal to "width".  Newline, \0, and AT indicator cause the
; iteration to stop.
;
; Returned pointer points at one char past the prefix.
; ie (return - s) is the number of chars in the prefix string.
;
; ===============================================================

SECTION code_font_fzx

PUBLIC asm_fzx_string_partition

EXTERN __fzx_glyph_width, _fzx

asm_fzx_string_partition:

   ; enter : de = char *s
   ;         hl = allowed width in pixels
   ;
   ; exit  : hl = s + prefixlen(s)
   ;         ix = struct fzx_font *
   ;
   ;         carry reset if stopped with room available
   ;         de = remaining width in pixels
   ;
   ;         carry set if width exceeded
   ;         de = - remaining width in pixels
   ;
   ; uses  : af, bc, de, hl, ix

   ld ix,(_fzx + 0)            ; ix = current font
   dec de

loop_consume:

   inc de
   ld a,(de)
   
   or a
   jr z, end_string
   
   cp 13                       ; terminate at newline
   jr z, end_string
   
   cp 22                       ; terminate at AT sequence
   jr z, end_string

   push hl
   
   call __fzx_glyph_width
   ld c,a
   ld b,0                      ; bc = char width
   
   pop hl
   sbc hl,bc                   ; is there room for the char?
   jr nc, loop_consume

end_string:

   ex de,hl
   ret

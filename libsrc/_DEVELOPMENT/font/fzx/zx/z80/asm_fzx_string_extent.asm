
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================
;
; uint fzx_string_extent(char *s)
;
; Returns the width of the string in pixels.  Characters left
; undefined by the font are treated as '?'.  Unprinted chars,
; which include '\n' and three-byte AT sequences, are considered
; zero width.
; ===============================================================

SECTION seg_code_fzx

PUBLIC asm_fzx_string_extent

EXTERN __fzx_width_sm, _fzx, error_zc

asm_fzx_string_extent:

   ; enter : hl = char *s
   ; 
   ; exit  : hl = width of string in pixels
   ;         de = address of terminating \0 in s
   ;         ix = struct fzx_font *
   ;
   ; uses  : af, bc, de, hl, ix

   ex de,hl                    ; de = char *s
   ld ix,(_fzx + 0)            ; ix = current font; struct fzx_font *

   ld hl,0                     ; current width = 0
   
loop_string:

   ld b,1                      ; b = num chars to skip in string + 1
   push hl

loop_unprintable:

   ld a,(de)                   ; end of string reached?
   or a
   jr z, end_string
   inc de

   call __fzx_width_sm         ; get width of glyph
   jr c, loop_unprintable      ; ignore unprintable char
   
   pop hl                      ; hl = current width of string
   
   add a,l                     ; add glyph width
   ld l,a
   jr nc, loop_string
   
   inc h
   jr loop_string
   
end_string:

   pop hl                      ; hl = string width in pixels
   
   ld a,h
   or l
   ret z
   
   ; need to subtract font tracking from last char
   
   ld c,(ix+1)                 ; font tracking
   ld b,0
   
   sbc hl,bc
   ret

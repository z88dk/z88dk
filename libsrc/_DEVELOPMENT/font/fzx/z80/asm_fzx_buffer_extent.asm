
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================
;
; uint fzx_buffer_extent(void *buf, uint len)
;
; Returns the width of the buffer of chars in pixels.  Characters
; left undefined by the font are treated as '?'.  Unprinted chars,
; which include '\n' and three-byte AT sequences, are considered
; zero width.
;
; Lies a little bit about the width -- the kern of the first
; printable char in the string is subtracted from true width.
; The driver kerns the first char of all strings so this allows
; things like right justification and decimal point alignment
; to work simply.
; ===============================================================

PUBLIC asm_fzx_buffer_extent

EXTERN __fzx_width_sm, _fzx, error_zc

asm_fzx_buffer_extent:

   ; enter : hl = void *buf
   ;         de = uint len
   ;
   ; exit  : hl = width of string in pixels
   ;         de = buf + len
   ;         ix = struct fzx_font *
   ;
   ; uses  : af, bc, de, hl, ix
   
   ld ix,(_fzx + 0)            ; ix = current font = struct fzx_font *
   
   push hl
   ld hl,0
   
loop_string:

   ld b,1                      ; b = num chars to skip in string + 1
   ex (sp),hl                  ; hl = void *buf, stack = width of string
   
loop_unprintable:

   ; de = remaining len in buffer
   ;  b = num chars to skip + 1
   ; hl = void *buf
   ; stack = width of string
   
   ld a,d                      ; end of buffer reached?
   or e
   jr z, end_string

   ld a,(hl)                   ; a = char
   inc hl
   dec de
   
   push hl
   call __fzx_width_sm         ; get width of glyph
   pop hl
   jr c, loop_unprintable      ; ignore unprintable char
   
   ex (sp),hl                  ; hl = current width of string
   
   add a,l                     ; add glyph width
   ld l,a
   jr nc, loop_string
   
   inc h
   jr loop_string
   
end_string:

   ex de,hl                    ; de = void *buf
   pop hl                      ; hl = string width in pixels
   
   ld a,h
   or l
   ret z
   
   ; need to subtract font tracking from last char
   
   ld c,(ix+1)                 ; font tracking
   ld b,0
   
   sbc hl,bc
   ret

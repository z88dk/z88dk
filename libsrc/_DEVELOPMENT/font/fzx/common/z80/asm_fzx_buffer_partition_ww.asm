
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================
;
; void *fzx_buffer_partition_ww(void *buf, uint len, uint width)
;
; Finds longest prefix string of buf that has pixel width less than
; or equal to "width" and whose words fit in the space allotted.
; Words are terminated by space, newline, and AT sequences.
; Newline, and AT indicator cause the iteration to stop.
;
; Returned pointer points at one char past the prefix.
; ie (return - buf) is the number of chars in the prefix string.
;
; ===============================================================

PUBLIC asm_fzx_buffer_partition_ww

EXTERN __fzx_glyph_width, _fzx

asm_fzx_buffer_partition_ww:

   ; enter : de = void *buf
   ;         bc = uint len
   ;         hl = uint width
   ;
   ; exit  : hl = buf + prefixlen
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

   push hl
   push bc
   ld a,' '
   call __fzx_glyph_width
   pop bc
   ld l,a
   ld h,0
   ex de,hl                    ; de = width of space in pixels

loop_ws:

   ; bc = uint len
   ; de = width of space
   ; hl = void *buf
   ; stack = remaining width
   
   ld a,b                      ; end of buffer?
   or c
   jr z, end_string_ws
   
   ld a,(hl)   
   cp ' '                      ; next word starting?
   jr nz, next_word

word_join:

   ex (sp),hl                  ; hl = remaining width
   sbc hl,de                   ; is there room for a space?
   ex (sp),hl
   jr c, end_string_ws
   
   inc hl
   dec bc
   jr loop_ws

end_string_ws:

   pop de                      ; de = remaining width in pixels
   ret

next_word:

   ex de,hl
   ex (sp),hl
   push de
   
   ; bc = uint len
   ; de = void *buf
   ; hl = remaining width
   ;  a = char
   ; stack = width of space, prefix ptr

loop_word:

   cp 13                       ; terminate at newline
   jr z, end_string_ww_accept
   
   cp 22                       ; terminate at AT sequence
   jr z, end_string_ww_accept
   
   cp ' '                      ; end of word?
   jr z, end_word
   
   push bc
   push hl
   
   call __fzx_glyph_width
   ld c,a
   ld b,0                      ; bc = char width
   
   pop hl
   sbc hl,bc                   ; is there room for the char?
   pop bc
   jr c, end_string_ww_reject
   
   dec bc
   inc de
   
   ld a,b                      ; end of buffer?
   or c
   ld a,(de)                   ; get next char
   jr nz, loop_word
   
end_string_ww_accept:

   ex de,hl                    ; hl = buf + prefixlen
   
   pop bc                      ; junk items on stack
   pop bc
   ret

end_string_ww_reject:

   ex de,hl
   
   pop hl                      ; hl = buf + prefixlen
   pop bc
   ret

end_word:

   ; word accepted
   
   ; bc = uint len
   ; de = void *buf
   ; hl = remaining width
   ; stack = width of space, prefix ptr

   pop af
   ex (sp),hl
   ex de,hl

   ; bc = uint len
   ; de = width of space
   ; hl = void *buf
   ; stack = remaining width

   jr word_join

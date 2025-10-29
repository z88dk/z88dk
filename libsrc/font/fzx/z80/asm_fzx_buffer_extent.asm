
; uint16_t fzx_buffer_extent(struct fzx_font *ff, char *buf, uint16_t buflen)

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_buffer_extent

EXTERN asm_fzx_glyph_width, error_znc

asm_fzx_buffer_extent:

   ; return width of buffer in pixels
   ;
   ; unprintable chars treated as '?'
   ; last char does not include additional tracking
   ;
   ; enter : hl = struct fzx_font *
   ;         de = char *buf
   ;         bc = unsigned int buflen
   ;
   ; exit  : hl = string extent in pixels
   ;         de = buf + buflen
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   jp z, error_znc             ; if empty buffer

   inc hl                      ; hl = & fzx_font.tracking
   
   push hl
   ld hl,0
   ex (sp),hl                  ; extent = 0 pixels

loop:

   ld a,(de)
   inc de
   
   ;  a = current char
   ; hl = & fzx_font.tracking
   ; de = char *buf (next char)
   ; bc = buflen
   ; stack = extent
   
   push bc
   push hl
   
   dec hl                      ; hl = struct fzx_font *
   call asm_fzx_glyph_width
   
   pop hl
   
   inc a
   add a,(hl)                  ; a = glyph width + tracking
   
   pop bc                      ; bc = buflen
   ex (sp),hl                  ; hl = extent
   
   add a,l
   ld l,a                      ; extent += glyph width + tracking
   jr nc, no_inc
   inc h
   
no_inc:

   ex (sp),hl                  ; hl = & fzx_font.tracking
   
   dec bc
   
   ld a,b
   or c
   jr nz, loop
   
   ; remove tracking on last char
   
   ld c,(hl)
   ld b,0                      ; bc = tracking
   
   pop hl                      ; hl = extent
   
;;   scf
   sbc hl,bc
   
   ret


; uint16_t fzx_string_extent(struct fzx_font *ff, char *s)

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_string_extent

EXTERN asm_fzx_glyph_width, error_znc

asm_fzx_string_extent:

   ; return width of string in pixels
   ;
   ; unprintable chars treated as '?'
   ; last char does not include additional tracking
   ;
   ; enter : hl = struct fzx_font *
   ;         de = char *s
   ;
   ; exit  : hl = string extent in pixels
   ;         de = points at terminating NUL in s
   ;
   ; uses  : af, bc, de, hl

   ld a,(de)
   or a
   jp z, error_znc             ; if zero length string

   inc hl                      ; hl = & fzx_font.tracking
   
   ld bc,0
   push bc                     ; extent = 0 pixels
   
loop:

   inc de
   
   ;  a = current char
   ; hl = & fzx_font.tracking
   ; de = char *s (next char)
   ; stack = extent
   
   push hl                     ; save & fzx_font.tracking

   dec hl                      ; hl = struct fzx_font *
   call asm_fzx_glyph_width
   
   pop hl
   
   inc a
   add a,(hl)                  ; a = glyph width + tracking
   
   ex (sp),hl                  ; hl = extent
   
   ld c,a
   ld b,0
   add hl,bc                   ; extent += glyph width + tracking
   
   ex (sp),hl                  ; hl = & fzx_font.tracking
   
   ld a,(de)
   or a
   jr nz, loop
   
   ; remove tracking on last char
   
   ld c,(hl)                   ; bc = tracking
   pop hl                      ; hl = string extent
   
;;   scf
   sbc hl,bc
   
   ret

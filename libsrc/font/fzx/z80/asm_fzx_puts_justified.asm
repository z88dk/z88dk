
; int fzx_puts_justified(struct fzx_state *fs, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_puts_justified

EXTERN __fzx_puts_newline
EXTERN error_mc, error_znc, l_inc_sp, l_divu_16_16x16
EXTERN asm_fzx_string_extent, asm_strchr, asm_fzx_putc

asm_fzx_puts_justified:

   ; enter : ix = struct fzx_state *
   ;         hl = char *s
   ;         bc = allowed_width in pixels
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail if string extent exceeds allowed_width
   ;
   ;            hl = -1
   ;            carry set
   ;
   ;         fail if y bounds exceeded
   ;
   ;            hl = next unprinted char *s
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, af'

   ld a,(hl)
   or a
   jp nz, error_znc

   ; find out amount of additional padding required

   push hl                     ; save char *s
   push hl                     ; save char *s
   push bc                     ; save allowed_width
   
   ex de,hl                    ; de = char *s
   
   ld l,(ix+3)
   ld h,(ix+4)                 ; hl = struct fzx_font *
   
   call asm_fzx_string_extent
   
   ; hl = string extent in pixels
   ; stack = char *s, char *s, allowed_width
   
   ex de,hl                    ; de = string extent
   pop hl                      ; hl = allowed_width
   
   or a
   sbc hl,de                   ; hl = additional_padding in pixels
   
   jp c, error_mc - 2          ; if string extent exceeds allowed width
   
   ex (sp),hl
   
   ; count number of spaces in string
   
   ; hl = char *s
   ; stack = char *s, additional_padding

   ld c,' '
   ld de,-1

count_loop:

   inc de                      ; number of spaces found so far
   
   call asm_strchr
   inc hl                      ; move past space
   
   jr nc, count_loop           ; if space found
   
   ; compute distributed padding
   
   pop hl                      ; hl = additional_padding
   push de
   
   ; hl = additional_padding in pixels
   ; de = number of spaces
   ; stack = char *s, number of spaces
   
   ld a,d
   or e
   jr z, number_spaces_zero
   
   call l_divu_16_16x16
   
   ex de,hl                    ; hl = remainder_padding, de = extra_padding
   add hl,de                   ; hl = last_padding

number_spaces_zero:

   pop bc
   ex (sp),hl
   push de

   ; output string with padding

   ; hl = char *s
   ; bc = number of spaces
   ; stack = last_padding, extra_padding

puts_loop:

   ld a,(hl)
   or a
   jp z, error_znc - 2         ; return success
   
   push bc
   push hl
   
   ld c,a
   call asm_fzx_putc
   
   jr c, off_screen
   
   pop hl
   pop bc
   
   ld a,(hl)
   inc hl
   
   cp ' '
   jr nz, puts_loop
   
   ; space encountered
   
   ; hl = char *s
   ; bc = number of spaces
   ; stack = remainder_padding, extra_padding

   pop de                      ; de = extra_padding
   
   dec bc

   ld a,b
   or c
   jr nz, add_spacing
   
   ; last space
   
   pop de                      ; de = last_padding
   push de

add_spacing:

   push de

   ; hl = char *s
   ; bc = number of spaces
   ; de = spacing
   ; stack = last_padding, extra_padding

   push hl

   ld l,(ix+5)
   ld h,(ix+6)                 ; hl = x coord
   
   add hl,de
   
   ld (ix+5),l
   ld (ix+6),h                 ; store new x coord
   
   pop hl
   jr puts_loop

off_screen:

   ; stack = last_padding, extra_padding, number of spaces, char *s

   dec a
   jr nz, newline
   
   ; y went out of bounds, must bail
   
   pop hl                      ; hl = next char *s
   jp l_inc_sp - 6

newline:

   call __fzx_puts_newline

   pop hl
   pop bc
   
   jr puts_loop

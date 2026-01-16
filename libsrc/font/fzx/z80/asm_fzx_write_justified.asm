
; int fzx_write_justified(struct fzx_state *fs, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_write_justified

EXTERN __fzx_puts_newline
EXTERN error_mc, error_znc, l_inc_sp, l_divu_16_16x16
EXTERN asm_fzx_buffer_extent, asm_fzx_putc

asm_fzx_write_justified:

   ; enter : ix = struct fzx_state *
   ;         de = char *buf
   ;         bc = unsigned int buflen
   ;         hl = allowed_width in pixels
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
   ;            hl = next unprinted char *buf
   ;            bc = buflen remaining
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, af'

   ld a,b
   or c
   jp z, error_znc

   ; find out amount of additional padding required
   
   push de                     ; save char *buf
   push bc                     ; save buflen

   push de                     ; save char *buf
   push bc                     ; save buflen

   push hl                     ; save allowed_width
   
   ld l,(ix+3)
   ld h,(ix+4)                 ; hl = struct fzx_font *
   
   call asm_fzx_buffer_extent
   
   ; hl = buffer extent in pixels
   ; stack = char *buf, buflen, char *buf, buflen, allowed_width
   
   ex de,hl                    ; de = buffer extent
   pop hl                      ; hl = allowed_width
   
   or a
   sbc hl,de                   ; hl = additional_padding in pixels
   
   pop bc                      ; bc = buflen
   ex (sp),hl                  ; hl = char *buf
   
   jp c, error_mc - 3          ; if buffer extent exceeds allowed width
   
   ; count number of spaces in buffer
   
   ; hl = char *buf
   ; bc = buflen
   ; stack = char *buf, buflen, additional_padding
   
   ld a,' '
   ld de,0

count_loop:

   cpir
   jr nz, no_space
   
   inc de                      ; increase number of spaces found
   jp pe, count_loop

no_space:

   pop hl                      ; hl = additional_padding
   push de

   ; compute distributed padding
   
   ; hl = additional_padding in pixels
   ; de = number of spaces
   ; stack = char *buf, buflen, number of spaces
   
   ld a,d
   or e
   jr z, number_spaces_zero
   
   call l_divu_16_16x16
   
   ex de,hl                    ; hl = remainder_padding, de = extra_padding
   add hl,de                   ; hl = last_padding

number_spaces_zero:

   pop af
   pop bc
   ex (sp),hl
   push de
   push af

write_loop:

   ; hl = char *buf
   ; bc = buflen
   ; stack = last_padding, extra_padding, number of spaces
   
   push bc
   push hl
   
   ld c,(hl)
   call asm_fzx_putc
   
   jr c, off_screen
   
   pop hl
   pop bc
   
   ld a,(hl)
   cp ' '
   
   jr z, insert_spacing
   
loop_rejoin:

   cpi                         ; hl++, bc--
   jp pe, write_loop
   
   jp error_znc - 3            ; success

insert_spacing:

   ; hl = char *buf
   ; bc = buflen
   ; stack = last_padding, extra_padding, number of spaces
   
   pop de                      ; de = number of spaces
   ex (sp),hl                  ; hl = extra_padding

   dec de

   ld a,d
   or e
   jr nz, add_spacing
   
   ; last space
   
   ; de = number of spaces = 0
   ; bc = buflen
   ; stack = last_padding, char *buf

   pop de
   pop hl                      ; hl = last_padding
   
   push hl
   push de

add_spacing:
   
   ; hl = extra_padding
   ; de = number of spaces
   ; bc = buflen
   ; stack = last_padding, char *buf
   
   ex de,hl                    ; de = extra_padding
   push hl                     ; save number of spaces
   
   ld l,(ix+5)
   ld h,(ix+6)                 ; hl = x coord
   
   add hl,de
   
   ld (ix+5),l
   ld (ix+6),h                 ; store new x coord
   
   pop hl                      ; hl = number of spaces
   ex de,hl                    ; de = number of spaces
   
   ex (sp),hl                  ; hl = char *buf
   push de
   
   jr loop_rejoin

off_screen:

   ; stack = last_padding, extra_padding, number of spaces, buflen, char *buf

   dec a
   jr nz, newline
   
   ; y went out of bounds, must bail
   
   pop hl                      ; hl = next char *buf
   pop bc                      ; bc = buflen remaining
   
   jp l_inc_sp - 6

newline:

   call __fzx_puts_newline

   pop hl
   pop bc
   
   jr write_loop

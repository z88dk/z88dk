
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_iterm_msg_bs_pwd
PUBLIC console_01_output_fzx_iterm_msg_bs_pwd_join

EXTERN l_offset_ix_de, l0_divu_16_16x16, l_mulu_16_16x16
EXTERN asm_fzx_glyph_width, console_01_output_fzx_proc_linefeed
EXTERN console_01_output_fzx_iterm_msg_bs_join_pwd

console_01_output_fzx_iterm_msg_bs_pwd:

;   Backspace: erase the last char.  The input terminal
;   is in password mode so all characters are printed
;   to screen as CHAR_PASSWORD.
;
;   enter  :  e = CHAR_PASSWORD
;            bc = int edit_buffer_len > 0
;   can use: af, bc, de, hl, ix

   dec bc                      ; do not include last char in buffer

   push ix                     ; save FDSTRUCT.JP *
   push de                     ; save CHAR_PASSWORD

console_01_output_fzx_iterm_msg_bs_pwd_join:

   ; ix = FDSTRUCT.JP *
   ; bc = int edit_buffer_len >= 0
   ;  e = CHAR_PASSWORD
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD

   push bc                     ; save buflen
   
   ld a,e                      ; a = CHAR_PASSWORD
   
   ld hl,30
   call l_offset_ix_de
   
   push hl
   pop ix                      ; ix = struct fzx_state *
   
   ; copy edit buffer (x,y) into current (x,y)
   
   ld l,(ix-3)
   ld h,(ix-2)
   
   ld (ix+7),l
   ld (ix+8),h                 ; y = edit_y

   ld l,(ix-5)
   ld h,(ix-4)
   
   ld (ix+5),l
   ld (ix+6),h                 ; x = edit_x

   ; ix = struct fzx_state *
   ;  a = CHAR_PASSWORD
   ; hl = edit_x
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD, buflen
   
   ; compute number of password chars fitting in a line
   
   ld e,(ix+17)
   ld d,(ix+18)                ; de = left_margin

   sbc hl,de
   add hl,de
   
   jr nc, edit_x_ok            ; if edit_x >= left_margin

   ld l,e
   ld h,d                      ; hl = left_margin

edit_x_ok:

   ; ix = struct fzx_state *
   ;  a = CHAR_PASSWORD
   ; de = left_margin
   ; hl = true edit_x
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD, buflen

   push hl                     ; save edit_x
   
   ld l,(ix+11)
   ld h,(ix+12)                ; hl = paper.width
   
   push hl                     ; save paper.width
   
   or a
   sbc hl,de                   ; hl = allowed_width (full_line)
   
   pop de                      ; de = paper.width
   ex (sp),hl                  ; hl = edit_x
   
   ex de,hl
   sbc hl,de                   ; hl = allowed_width (first_line)
   
   push hl

   ld l,(ix+3)
   ld h,(ix+4)                 ; hl = struct fzx_font *

   ; ix = struct fzx_state *
   ;  a = CHAR_PASSWORD
   ; hl = struct fzx_font *
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD, buflen, allowed_width (full_line), allowed_width (first_line)
   
   inc hl
   
   ld e,(hl)
   ld d,0
   
   dec hl

   ; ix = struct fzx_state *
   ;  a = CHAR_PASSWORD
   ; hl = struct fzx_font *
   ; de = tracking
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD, buflen, allowed_width (full_line), allowed_width (first_line)
   
   call asm_fzx_glyph_width    ; a = width - 1 - kern
   
   inc a
   add a,e                     ; a = glyph width + tracking
   
   pop hl
   add hl,de                   ; allowed_width (first_line) += tracking
   
   ex (sp),hl
   add hl,de                   ; allowed_width (full_line) += tracking
   
   ld e,a

   ; ix = struct fzx_state *
   ; hl = allowed_width (full_line)
   ; de = glyph_width + tracking
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD, buflen, allowed_width (first_line)
   
   push de                     ; save glyph_width + tracking
   
   call l0_divu_16_16x16       ; hl = num_fit (full_line)
   
   pop de                      ; de = glyph_width + tracking
   ex (sp),hl                  ; hl = allowed_width(first_line)
   
   push de
   
   call l0_divu_16_16x16       ; hl = num_fit (first_line)
   
   pop de
   
   ld c,l
   ld b,h

   ; ix = struct fzx_state *
   ; bc = num_fit (first_line)
   ; de = pixel_width_pwd_char = glyph_width + tracking
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD, buflen, num_fit (full_line)
   
   pop af
   pop hl
   push de
   push af

   ; ix = struct fzx_state *
   ; hl = buflen
   ; bc = num_fit (first_line)
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD, pixel_width_pwd_char, num_fit (full_line)

partition_loop:

   ; partition password buffer and advance (x,y) coordinate
   
   ; ix = struct fzx_state *
   ; hl = buflen
   ; bc = num_fit (current line)
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD, pixel_width_pwd_char, num_fit (full line)
   
   or a
   sbc hl,bc
   
   jr z, position_found
   jr c, position_found
   
advance_line:

   ; ix = struct fzx_state *
   ; hl = buflen
   ; bc = num_fit
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD, pixel_width_pwd_char, num_fit

   push hl
   
   call console_01_output_fzx_proc_linefeed
   
   pop hl

   pop bc
   push bc
   
   jr partition_loop

position_found:

   add hl,bc
   pop bc

   ; ix = struct fzx_state *
   ; hl = buflen fits line
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD, pixel_width_pwd_char

   pop de
   call l_mulu_16_16x16        ; hl = pixel x offset of last char

   ; ix = struct fzx_state *
   ; hl = pixel offset of last char
   ; stack = FDSTRUCT.JP *, CHAR_PASSWORD
   
   ld e,(ix+5)
   ld d,(ix+6)                 ; de = x coord
   
   add hl,de                   ; hl = x coord of last char
   
   jp console_01_output_fzx_iterm_msg_bs_join_pwd


SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_iterm_msg_bs
PUBLIC console_01_output_fzx_iterm_msg_bs_join
PUBLIC console_01_output_fzx_iterm_msg_bs_join_pwd

EXTERN asm_fzx_buffer_partition, asm_fzx_putc
EXTERN l_offset_ix_de, console_01_output_fzx_proc_linefeed

console_01_output_fzx_iterm_msg_bs:

   ; backspace: erase the last char of the edit buffer.
   ;
   ; enter  : ix = FDSTRUCT.JP *
   ;          de = char *edit_buffer
   ;          bc = int edit_buffer_len > 0
   ;
   ; can use: af, bc, de, hl, ix

   ; THE ALTERNATIVE HERE IS TO PRINT THE EDIT BUFFER
   ; FROM THE EDIT (X,Y) COORDINATE USING AN FZX_DRAW
   ; FUNCTION THAT DOES NOTHING.  THE CODE WOULD BE
   ; SMALL BUT I BELIEVE TOO SLOW.
   
   ; THIS CODE 'SIMULATES' THE PRINTING BY MEASURING
   ; THE PIXEL WIDTH OF THE EDIT BUFFER AND ADVANCING
   ; THE EDIT (X,Y) COORDINATE BY THE PIXEL WIDTH OF
   ; CHARS WITHOUT PRINTING THEM.

   push ix                     ; save FDSTRUCT.JP *

   ; determine which char is being erased

   dec bc                      ; buflen now excludes last char

   ld l,e
   ld h,d
   
   add hl,bc
   ld l,(hl)
   
   push hl                     ; save last char of buffer (char erase)

console_01_output_fzx_iterm_msg_bs_join:

   ; ix = FDSTRUCT.JP *
   ; de = char *edit_buffer
   ; bc = edit_buffer_len >= 0
   ; stack = FDSTRUCT.JP *, char erase

   ; set ix = struct fzx_state *
   
   push de
   
   ld hl,30
   call l_offset_ix_de
   
   push hl
   pop ix
   
   ; copy edit buffer (x,y) into current (x,y)

   ld l,(ix-3)
   ld h,(ix-2)
   
   ld (ix+7),l
   ld (ix+8),h                 ; y = edit_y

   ld l,(ix-5)
   ld h,(ix-4)
   
   ld (ix+5),l
   ld (ix+6),h                 ; x = edit_x
   
   ; compute allowed_width, set up stack
   
   ; ix = struct fzx_state *
   ; bc = int edit_buffer_len >= 0
   ; hl = edit_x
   ; stack = FDSTRUCT.JP *, char erase, char *edit_buffer

   ld e,(ix+17)
   ld d,(ix+18)                ; de = left_margin

   sbc hl,de
   add hl,de
   
   jr nc, edit_x_ok            ; if edit_x >= left_margin

   ld l,e
   ld h,d                      ; hl = left_margin

edit_x_ok:

   ; ix = struct fzx_state *
   ; bc = int edit_buffer_len >= 0
   ; de = left_margin
   ; hl = true edit_x
   ; stack = FDSTRUCT.JP *, char erase, char *edit_buffer

   pop af
   push ix
   push af
   
   ; stack = FDSTRUCT.JP *, char erase, struct fzx_state *, char *edit_buffer

   push hl                     ; save edit_x
   
   ld l,(ix+11)
   ld h,(ix+12)                ; hl = paper.width
   
   push hl                     ; save paper.width
   
   or a
   sbc hl,de                   ; hl = allowed_width (full line)

   pop de                      ; de = paper.width
   ex (sp),hl                  ; hl = edit_x
   
   ex de,hl
   sbc hl,de                   ; hl = allowed_width (first line)
   
   ; ix = struct fzx_state *
   ; bc = int edit_buffer_len >= 0
   ; hl = allowed_width (first line)
   ; carry set if allowed_width (first line) < 0
   ; stack = FDSTRUCT.JP *, char erase, struct fzx_state *, char *edit_buffer, allowed_width (full line)
   
   ex de,hl                    ; de = allowed_width (first line)
   
   ld l,(ix+3)
   ld h,(ix+4)
   
   push hl
   pop ix                      ; ix = struct fzx_font *
   
   ; ix = struct fzx_font *
   ; bc = int edit_buffer_len >= 0
   ; de = allowed_width (first line)
   ; carry set if allowed_width (first line) < 0
   ; stack = FDSTRUCT.JP *, char erase, struct fzx_state *, char *edit_buffer, allowed_width (full line)

   jr nc, begin_first_line

begin_second_line:

   pop hl
   pop de
   
   ; ix = struct fzx_font *
   ; hl = allowed_width
   ; de = buf + prefix_len
   ; bc = remaining buflen
   ; stack = FDSTRUCT.JP *, char erase, struct fzx_state *

   jr advance_line

begin_first_line:

   ; ix = struct fzx_font *
   ; bc = int edit_buffer_len >= 0
   ; de = allowed_width (first line)
   ; stack = FDSTRUCT.JP *, char erase, struct fzx_state *, char *edit_buffer, allowed_width (full line)

   ex de,hl                    ; hl = allowed_width (first line)
   
   pop af
   pop de
   push af

partition_loop:

   ; partition buffer and advance (x,y) coordinate
   
   ; ix = struct fzx_font *
   ; hl = allowed_width
   ; de = char *buf
   ; bc = buflen
   ; stack = FDSTRUCT.JP *, char erase, struct fzx_state *, allowed_width
   
   call asm_fzx_buffer_partition
   jr nc, position_found

   ; not all chars can fit line
   ; so advance y coordinate

   ex de,hl
   pop hl

advance_line:

   ; ix = struct fzx_font *
   ; hl = allowed_width
   ; de = buf + prefix_len
   ; bc = remaining buflen
   ; stack = FDSTRUCT.JP *, char erase, struct fzx_state *
   
   ex (sp),ix
   
   push de
   push hl
   
   call console_01_output_fzx_proc_linefeed
   
   pop hl
   pop de
   
   ex (sp),ix
   
   push hl
   jr partition_loop

position_found:

   ; advance x coord in current line
   
   ; ix = struct fzx_font *
   ; de = remaining allowed_width
   ; stack = FDSTRUCT.JP *, char erase, struct fzx_state *, allowed_width
   
   pop bc                      ; junk item
   
   ld c,(ix+1)
   ld b,0                      ; bc = tracking
   
   pop ix                      ; ix = struct fzx_state *

   ld l,(ix+11)
   ld h,(ix+12)                ; hl = paper.width

   sbc hl,de                   ; hl = paper.width - remaining_width
   add hl,bc                   ; undo tracking added to remaining_width by fzx_buffer_partition

console_01_output_fzx_iterm_msg_bs_join_pwd:

   pop bc

   ; ix = struct fzx_state *
   ; hl = x coord of last char
   ;  c = char erase
   ; stack = FDSTRUCT.JP *
   
   ld (ix+5),l
   ld (ix+6),h                 ; store new x coord

   ; overwrite last char to erase it
   
   ; ix = struct fzx_state *
   ; hl = x coord of last char
   ;  c = char erase
   ; stack = FDSTRUCT.JP *
   
   push hl                     ; save x coord
   
   ld l,(ix+7)
   ld h,(ix+8)
   
   push hl                     ; save y coord

putchar_loop:

   push bc                     ; save char
   
   call asm_fzx_putc
   
   pop bc                      ; c = char to erase
   jr nc, backspace_done
   
   ; can only fail if no fit horizontally
   
   dec a
   jr z, backspace_done        ; failed to fit vertically, cannot happen so give up
   
   call console_01_output_fzx_proc_linefeed
   jr putchar_loop

backspace_done:

   ; ix = struct fzx_state *
   ; stack = FDSTRUCT.JP *, x coord, y coord
   
   pop hl
   
   ld (ix+7),l
   ld (ix+8),h                 ; restore y coord of last char
   
   pop hl
   
   ld (ix+5),l
   ld (ix+6),h                 ; restore x coord of last char

   pop ix
   ret

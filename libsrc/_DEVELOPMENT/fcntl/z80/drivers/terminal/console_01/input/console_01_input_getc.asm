
SECTION seg_code_fcntl

PUBLIC console_01_input_getc

EXTERN console_01_input_echo, l_setmem_hl, asm_b_array_clear
EXTERN ITERM_MSG_READLINE, console_01_input_oterm, l_inc_sp
EXTERN CHAR_CURSOR_UC, CHAR_CURSOR_LC, ITERM_MSG_PRINT_CURSOR
EXTERN ITERM_MSG_ERASE_CURSOR, CHAR_BS, ITERM_MSG_BS, CHAR_LF
EXTERN asm_b_array_push_back, asm_b_array_at, ITERM_MSG_GETC
EXTERN l_jpix, CHAR_CR, CHAR_CAPS, CHAR_ESC

console_01_input_getc:

   ; enter : ix = & FDSTRUCT.JP
   ;
   ; exit  : success
   ;
   ;            a = hl = char
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0 on stream error, -1 on eof
   ;            carry set
   ;
   ; uses  : af, hl

   push bc
   push de
   
   call getc
   
   pop de
   pop bc
   
   ret c                       ; if error
   
   ld l,a
   ld h,0                      ; a = hl = char
   
   ret

getc:

   bit 5,(ix+6)
   jr nz, line_mode

char_mode:

   call state_machine_0        ; get char from device
   ret c                       ; if driver error
   
   push af                     ; save char
   call console_01_input_echo  ; output to terminal
   pop af                      ; a = char
   
   ret

line_mode:

   ; try to get char from edit buffer
   
   push ix
   pop hl                      ; hl = & FDSTRUCT.JP
   
   ld de,17
   add hl,de                   ; hl = & FDSTRUCT.read_index
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = read_index
   inc hl                      ; hl = & FDSTRUCT.b_array

   ; bc = read_index
   ; hl = & FDSTRUCT.b_array
   
   ld a,(hl)                   ; examine b_array.data
   inc hl
   or (hl)
   dec hl
   jr z, char_mode             ; if edit buffer does not exist
   
   call line_mode_editbuf_1
   ret nc                      ; if char retrieved from edit buffer
   
   ; fall through to line_mode_readline

line_mode_readline:

   ; hl = & FDSTRUCT.b_array

   dec hl
   dec hl                      ; hl = & FDSTRUCT.read_index
   
   xor a
   call l_setmem_hl - 4        ; FDSTRUCT.read_index = 0

   push hl                     ; save b_array *
   
   call asm_b_array_clear      ; empty the edit buffer
   
   bit 7,(ix+6)
   jr z, readline_loop         ; if echo off
   
   ld a,ITERM_MSG_READLINE
   call console_01_input_oterm ; inform output terminal that new line is starting

readline_loop:

   ; stack = & FDSTRUCT.b_array

   ; print cursor
   
   bit 7,(ix+6)
   jr z, cursor_print_end      ; if echo off
   
   bit 1,(ix+7)
   jr z, cursor_print_end      ; if no cursor

   ld c,CHAR_CURSOR_UC
   
   bit 3,(ix+6)
   jr nz, cursor_print         ; if caps lock is on
   
   ld c,CHAR_CURSOR_LC

cursor_print:

   ld a,ITERM_MSG_PRINT_CURSOR
   call console_01_input_oterm ; instruct output terminal to print cursor

cursor_print_end:

   ; read char from device

   ; stack = & FDSTRUCT.b_array

   call state_machine_0        ; a = next char
   
   ; erase cursor
   
   bit 7,(ix+6)
   jr z, cursor_erase_end      ; if echo off
   
   bit 1,(ix+7)
   jr z, cursor_erase_end      ; if no cursor
   
   pop de
   push de
   
   push af
   push hl
   
   ex de,hl                    ; hl = & FDSTRUCT.b_array
   call edit_buff_params       ; de = char *edit_buffer, bc = edit_buffer_len
   
   ld a,ITERM_MSG_ERASE_CURSOR
   call console_01_input_oterm ; instruct output terminal to erase cursor
   
   pop hl
   pop af
   
cursor_erase_end:

   ; process char

   ; a = char (carry on error with hl = 0 or -1)
   ; stack = & FDSTRUCT.b_array

   jr c, readline_error        ; if device reports error
   
   bit 7,(ix+7)
   jr nz, escaped_char         ; if this is an escaped char
   
   cp CHAR_BS
   jr nz, escaped_char         ; if not backspace
   
   ; backspace

   ; stack = & FDSTRUCT.b_array
   
   pop hl
   push hl
   
   call edit_buff_params
   
   ; de = b_array.data
   ; bc = b_array.size
   ; stack = & FDSTRUCT.b_array

   ld a,b
   or c
   jr z, readline_loop         ; if edit buffer is empty
   
   bit 7,(ix+6)
   jr z, skip_bs               ; if echo off
   
   push bc                     ; save b_array.size
   
   ld a,ITERM_MSG_BS
   call console_01_input_oterm ; instruct output terminal to backspace
   
   pop bc                      ; bc = b_array.size

skip_bs:

   pop hl
   push hl
   
   inc hl
   inc hl                      ; hl = & b_array.size
   
   dec bc                      ; b_array.size --
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; erase last char of edit buffer
   
   jr readline_loop

escaped_char:

   ; append char to edit buffer

   ; a = char
   ; stack = & FDSTRUCT.b_array
   
   pop hl
   push hl
   
   ld c,a
   call asm_b_array_push_back  ; append char to edit buffer
   
   jr c, readline_loop         ; if failed because buffer is full
   
   ; c = char
   ; stack = & FDSTRUCT.b_array
   
   ld a,c
   push af
   
   call console_01_input_echo  ; send char to output terminal
   
   pop af                      ; a = char
   
   cp CHAR_LF
   jr nz, readline_loop        ; if not LF continue reading

readline_done:
readline_error:

   ; return a char from the edit buffer

   ; hl = 0 or -1 if error
   ; stack = & FDSTRUCT.b_array

   ex (sp),hl                  ; hl = & FDSTRUCT.b_array
   ld bc,0                     ; read_index = 0
   
   call line_mode_editbuf_1
   jp nc, l_inc_sp - 2         ; if char successfully retrieved from buffer
   
   pop hl                      ; hl = 0 or -1
   ret

edit_buff_params:

   ; hl = & FDSTRUCT.b_array
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = b_array.data
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = b_array.size
   
   ret

line_mode_editbuf_1:

   ; enter : bc = read_index
   ;         hl = & FDSTRUCT.b_array
   ;
   ; exit  : success char available
   ;
   ;            a = char from edit buffer
   ;            carry reset
   ;
   ;         fail no char in edit buffer
   ;
   ;            hl = & FDSTRUCT.b_array
   ;            carry set

   push hl                     ; save & FDSTRUCT.b_array
   
   call asm_b_array_at         ; read char in edit buffer at index bc
   ld a,l                      ; a = char from edit buffer
   
   pop hl                      ; hl = & FDSTRUCT.b_array
   ret c                       ; if char not available

   inc bc                      ; read_index ++
   
   dec hl
   ld (hl),b
   dec hl
   ld (hl),c                   ; store new read_index

   ret

state_machine_0:

   ; return char in A or carry set with hl = 0 or -1 on driver error
   
   res 7,(ix+7)                ; clear escaped char indicator
   
   ld a,(ix+16)                ; a = pending char
   
   or a
   jr z, state_machine_1       ; if no pending char
   
   ld (ix+16),0                ; clear pending char
   jr state_machine_2          ; process pending char   

state_machine_1:

   ld a,ITERM_MSG_GETC
   call l_jpix                 ; get char from device
   
   ret c                       ; if device error

state_machine_2:

   cp CHAR_CR
   jr z, sm_crlf               ; possible crlf
   
   or a                        ; indicate no error
   
   bit 4,(ix+6)
   ret z                       ; if cook mode disabled

sm_cook:

   cp CHAR_CAPS
   jr z, sm_capslock
   
   cp CHAR_ESC
   jr z, sm_escape
   
   ; regular character
   
   bit 3,(ix+6)
   call nz, asm_toupper        ; if caps lock active

   or a                        ; indicate no error
   ret

sm_crlf:

   bit 0,(ix+7)
   ret z                       ; if not doing crlf conversion
   
   ld a,ITERM_MSG_GETC
   call l_jpix                 ; get char from device
   
   jr c, sm_crlf_exit          ; if device error

   cp CHAR_LF
   ret z                       ; crlf sequence seen, return lf
   
   or a                        ; indicate no error
   call sm_exit                ; store this char as pending char
   
   ld a,CHAR_CR                ; output solo cr
   ret

sm_crlf_exit:

   ld a,CHAR_CR                ; store CR as pending char
   jr sm_exit

sm_capslock:

   ld a,(ix+6)
   xor $08                     ; toggle caps lock bit
   ld (ix+6),a
   
   jr state_machine_1          ; read another char

sm_escape:

   ld a,ITERM_MSG_GETC
   call l_jpix                 ; get char from device
   
   set 7,(ix+7)                ; indicate an escaped char
   ret nc                      ; return raw char if no error

sm_esc_exit:

   ld a,CHAR_ESC               ; store ESC as pending char

   ; fall through to sm_exit

sm_exit:

   ; stateful exit
   
   ld (ix+16),a                ; store pending char
   ret

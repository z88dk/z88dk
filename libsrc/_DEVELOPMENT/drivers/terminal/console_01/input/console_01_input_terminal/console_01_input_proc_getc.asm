
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC console_01_input_proc_getc

EXTERN console_01_input_proc_echo, l_setmem_hl, asm_b_array_clear
EXTERN console_01_input_proc_oterm, l_inc_sp, l_jpix, l_offset_ix_de
EXTERN asm_b_array_push_back, asm_b_array_at, asm_toupper, error_zc, error_mc
EXTERN device_return_error, device_set_error

console_01_input_proc_getc:

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
   
   push af                          ; save char
   call console_01_input_proc_echo  ; output to terminal
   pop af                           ; a = char
   
   ret

line_mode:

   ; try to get char from edit buffer
   
   ld hl,17
   call l_offset_ix_de         ; hl = & FDSTRUCT.read_index
   
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

   bit 6,(ix+7)
   jr nz, line_mode_readline   ; if ioctl pushed edit buffer

   call line_mode_editbuf_1
   ret nc                      ; if char retrieved from edit buffer

line_mode_readline:

   ; hl = & FDSTRUCT.b_array

   dec hl
   dec hl                      ; hl = & FDSTRUCT.read_index
   
   xor a
   call l_setmem_hl - 4        ; FDSTRUCT.read_index = 0

   push hl                     ; save b_array *

   ld a,ITERM_MSG_READLINE_BEGIN
   call console_01_input_proc_oterm  ; inform output terminal that new line is starting

   pop hl                      ; hl = b_array *
   push hl
   
   bit 6,(ix+7)
   jr z, line_mode_readline_1
   
   res 6,(ix+7)

   ; ioctl pushed edit buffer into terminal
   ; need to echo buffer chars to output terminal
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = b_array.data
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = b_array.size

   ex de,hl

push_loop:

   ld a,b
   or c
   jr z, readline_loop

   ld a,(hl)

   cp CHAR_LF
   jr nz, put_raw_0

   ld a,'?'                    ; changed escaped LF to '?'

put_raw_0:

   push bc
   push hl
   
   call console_01_input_proc_echo  ; send char to output terminal

   pop hl
   pop bc
   
   inc hl
   dec bc

   jr push_loop

line_mode_readline_1:

   call asm_b_array_clear      ; empty the edit buffer

readline_loop:

   ; stack = & FDSTRUCT.b_array

   ; print cursor
   
   ld a,(ix+6)                ; a = ioctl_f0 flags
   
   add a,a
   jr nc, cursor_print_end     ; if echo off
   
   bit 1,(ix+7)
   jr z, cursor_print_end      ; if no cursor

   ld c,CHAR_CURSOR_LC
   
   and $30                     ; isolate cook and caps flags
   cp $30
   jr nz, cursor_print         ; if !cook || !caps
   
   ld c,CHAR_CURSOR_UC

cursor_print:

   ld a,ITERM_MSG_PRINT_CURSOR
   call console_01_input_proc_oterm  ; instruct output terminal to print cursor

cursor_print_end:

   ; read char from device

   ; stack = & FDSTRUCT.b_array

   call state_machine_0        ; a = next char
   
   ; erase cursor
   
   bit 7,(ix+6)
   jr z, cursor_erase_end      ; if echo off
   
   bit 1,(ix+7)
   jr z, cursor_erase_end      ; if no cursor
   
   pop hl
   push hl                     ; hl = & FDSTRUCT.b_array
   
   push af
   
   call edit_buff_params       ; de = char *edit_buffer, bc = int edit_buffer_len
   
   ld a,ITERM_MSG_ERASE_CURSOR

   bit 6,(ix+6)
   jr z, cursor_not_pwd        ; if not password mode
   
   ld a,ITERM_MSG_ERASE_CURSOR_PWD
   ld e,CHAR_PASSWORD

cursor_not_pwd:

   call console_01_input_proc_oterm  ; instruct output terminal to erase cursor
   
   pop af
   
cursor_erase_end:

   ; process char

   ; a = char (carry on error with hl = 0 or -1)
   ; stack = & FDSTRUCT.b_array

   jr c, readline_error        ; if device reports error
   
   bit 7,(ix+7)
   jr nz, escaped_char         ; if this is an escaped char
   
   cp CHAR_CAPS
   jr z, readline_loop         ; change cursor
   
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
   jr nz, not_empty            ; if edit buffer is not empty

   ; cannot backspace

bell:

   ld a,ITERM_MSG_BELL
   call console_01_input_proc_oterm  ; send to output terminal
   
   jr readline_loop

not_empty:

   bit 7,(ix+6)
   jr z, skip_bs               ; if echo off
   
   push bc                     ; save b_array.size
   
   ld a,ITERM_MSG_BS
   
   bit 6,(ix+6)
   jr z, not_password_mode

   ld a,ITERM_MSG_BS_PWD
   ld e,CHAR_PASSWORD

not_password_mode:

   call console_01_input_proc_oterm  ; instruct output terminal to backspace
   
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
   
   jp readline_loop

escaped_char:

   ; append char to edit buffer

   ; a = char
   ; stack = & FDSTRUCT.b_array
   
   pop hl
   push hl
   
   ld c,a
   call asm_b_array_push_back  ; append char to edit buffer
   
   jr c, bell                  ; if failed because buffer is full
   
   ; c = char
   ; stack = & FDSTRUCT.b_array
   
   ld a,c
   
   bit 7,(ix+7)
   jr z, put_raw               ; if not an escaped char
   
   cp CHAR_LF
   jr nz, put_raw

   ld a,'?'                    ; changed escaped LF to '?'

put_raw:

   push af
   
   ld c,a
   
   ld a,ITERM_MSG_INTERRUPT
   call l_jpix

   pop bc
   jr nc, interrupt_received

   ld a,b
   push af
   
   call console_01_input_proc_echo  ; send char to output terminal
   
   pop af                      ; a = char
   
   cp CHAR_LF
   jp nz, readline_loop

readline_done:
readline_error:

   ; return a char from the edit buffer

   ; hl = 0 or -1 if error
   ; stack = & FDSTRUCT.b_array
   
   push hl
   
   ld a,ITERM_MSG_READLINE_END
   call console_01_input_proc_oterm  ; inform output terminal that editing is done
   
   pop hl

   ex (sp),hl                  ; hl = & FDSTRUCT.b_array
   ld bc,0                     ; read_index = 0
   
   call line_mode_editbuf_1
   jp nc, l_inc_sp - 2         ; if char successfully retrieved from buffer
   
   pop hl                      ; hl = 0 or -1
   ret

interrupt_received:

   set 0,(ix+6)                ; place device in error state
   jr readline_done

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

   ld a,(ix+6)
   and $03                     ; check device state
   jp nz, device_return_error

   ld a,ITERM_MSG_GETC
   call l_jpix                 ; get char from device
   jp c, device_set_error

state_machine_2:

   cp CHAR_CR
   jr nz, not_cr

   bit 0,(ix+7)
   ret z                       ; if not doing crlf conversion

   jr state_machine_1          ; reject CR

not_cr:
   
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

sm_capslock:

   ld a,(ix+6)
   xor $08                     ; toggle caps lock bit
   ld (ix+6),a
   
   and $20
   jr z, state_machine_1       ; read another if char mode
   
   ld a,CHAR_CAPS
   ret

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

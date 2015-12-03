
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC console_01_input_stdio_msg_ictl
PUBLIC console_01_input_stdio_msg_ictl_0

EXTERN asm_vioctl_driver, error_einval_zc
EXTERN l_offset_ix_de, l_setmem_hl
EXTERN console_01_input_stdio_msg_flsh
EXTERN console_01_input_proc_reset

console_01_input_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_RESET             = $0000
   ; defc IOCTL_ITERM_TIE         = $0201
   ; defc IOCTL_ITERM_GET_EDITBUF = $0381
   ; defc IOCTL_ITERM_SET_EDITBUF = $0301
   ;
   ; in addition to flags managed by stdio
   ;
   ; enter : ix = & FDSTRUCT.JP
   ;         bc = first parameter
   ;         de = request
   ;         hl = void *arg (0 if stdio flags)
   ;
   ; exit  : hl = return value
   ;         carry set if ioctl rejected
   ;
   ; uses  : af, bc, de, hl

   ; flag bits managed by stdio?
   
   ld a,h
   or l
   jr nz, _ictl_messages
   
   ; if line mode is being disabled reset the edit buffer
   
   ld a,e
   and $20
   jp z, asm_vioctl_driver     ; if line mode not being disabled
   
   and c
   jp nz, asm_vioctl_driver    ; if line mode not being disabled
   
   call asm_vioctl_driver      ; set stdio flags
   
   push hl                     ; save return value
   
   call console_01_input_stdio_msg_flsh
   
   pop hl
   ret

_ictl_messages:

   ld a,e
   or d
   jp z, console_01_input_proc_reset   ; if IOCTL_RESET

   ; check the message is specifically for an input terminal
   
   ld a,e
   and $07
   cp $01                      ; input terminals are type $01
   jp nz, error_einval_zc

console_01_input_stdio_msg_ictl_0:

   ; interpret ioctl message
   
   ld a,d
   
   dec a
   dec a
   jr z, _ioctl_tie
   
   dec a
   jp nz, error_einval_zc

_ioctl_getset_editbuf:

   ; e & $80 = 1 for get
   ; bc = first parameter (b_array *)
   ; hl = void *arg

   ld a,e

   ld hl,16
   call l_offset_ix_de         ; hl = & fdstruct.pending_char
   
   ld e,c
   ld d,b                      ; de = & b_array
   
   add a,a
   jr c, _ioctl_get_editbuf

_ioctl_set_editbuf:

   set 6,(ix+7)                ; indicate buffer pushed into edit terminal

   xor a
   call l_setmem_hl - 6        ; hl = & fdstruct.b_array
   
   ex de,hl
   jr _ioctl_editbuf_copy

_ioctl_get_editbuf:

   inc hl
   inc hl
   inc hl                      ; hl = & fdstruct.b_array

_ioctl_editbuf_copy:

   ld bc,6
   ldir
   
   or a
   ret

_ioctl_tie:

   ; bc = first parameter (new oterm *)
   ; hl = void *arg

   call console_01_input_stdio_msg_flsh
   
   ld hl,14
   call l_offset_ix_de         ; hl = & fdstruct.oterm
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = old oterm
   
   ld a,b
   and c
   inc a
   jr z, _ioctl_tie_exit       ; if oterm == -1
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; store new oterm

_ioctl_tie_exit:

   ex de,hl                    ; hl = old oterm
   ret

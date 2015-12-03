
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_stdio_msg_ictl
PUBLIC console_01_output_char_stdio_msg_ictl_0

EXTERN OTERM_MSG_CLS

EXTERN asm_vioctl_driver, l_jpix, l_offset_ix_de
EXTERN error_einval_zc, __stdio_nextarg_bc, __stdio_nextarg_hl
EXTERN console_01_output_char_proc_reset_scroll_limit
EXTERN console_01_output_char_proc_putchar_scroll_adjust

console_01_output_char_stdio_msg_ictl:

   ; ioctl messages understood:
   ;
   ; defc IOCTL_OTERM_CLS              = $0102
   ; defc IOCTL_OTERM_RESET_SCROLL     = $0202
   ; defc IOCTL_OTERM_GET_WINDOW_COORD = $0382
   ; defc IOCTL_OTERM_SET_WINDOW_COORD = $0302
   ; defc IOCTL_OTERM_GET_WINDOW_RECT  = $0482
   ; defc IOCTL_OTERM_SET_WINDOW_RECT  = $0402
   ; defc IOCTL_OTERM_GET_CURSOR_COORD = $0582
   ; defc IOCTL_OTERM_SET_CURSOR_COORD = $0502
   ; defc IOCTL_OTERM_GET_OTERM        = $0602
   ; defc IOCTL_OTERM_SCROLL           = $0702
   ;
   ; in addition to flags managed by stdio.
   ;
   ; enter : de = request
   ;         bc = first parameter
   ;         hl = void *arg (0 if stdio flags)
   ;
   ; exit  : hl = return value
   ;         carry set if ioctl rejected
   ;
   ; uses  : af, bc, de, hl
   
   ; flag bits managed by stdio?
   
   ld a,h
   or l
   jp z, asm_vioctl_driver     ; accept all changes to stdio flags
   
   ; check that message is specifically for an output terminal
   
   ld a,e
   and $07
   cp $02                      ; output terminal messages are type $02
   jp nz, error_einval_zc

   ; interpret ioctl message

console_01_output_char_stdio_msg_ictl_0:
   
   ld a,d

   dec a
   jr z, _ioctl_cls
   
   dec a
   jp z, console_01_output_char_proc_reset_scroll_limit
   
   dec a
   jr z, _ioctl_getset_window_coord
   
   dec a
   jr z, _ioctl_getset_window_rect
   
   dec a
   jr z, _ioctl_getset_cursor_coord
   
   dec a
   jr z, _ioctl_get_oterm
   
   dec a
   jp nz, error_einval_zc

_ioctl_scroll:

   ; bc = first parameter (number of rows to scroll)

   ld a,c
   jp console_01_output_char_proc_putchar_scroll_adjust

_ioctl_get_oterm:

   ; return the address of this oterm's FDSTRUCT
   
   push ix
   pop hl
   
   dec hl
   dec hl
   dec hl
   
   ret

_ioctl_getset_cursor_coord:

   ; e & $80 = 1 for get
   ; bc = first parameter (x coord info)
   ; hl = void *arg

   rl e
   jr c, _ioctl_get_cursor_coord

_ioctl_set_cursor_coord:

   call __stdio_nextarg_hl
   
   ; c = x_coord
   ; l = y_coord
   
   ld h,l
   ld l,c
   
   ld (ix+14),l
   ld (ix+15),h
   
   ret

_ioctl_get_cursor_coord:

   ld e,(ix+14)                ; e = x_coord
   ld d,(ix+15)                ; d = y_coord

   ld a,e                      ; a = x_coord
   
   ld (bc),a
   inc bc
   
   xor a
   ld (bc),a
   
   call __stdio_nextarg_bc
   
   inc bc
   ld (bc),a
   
   ld a,d                      ; a = y_coord
   
   dec bc
   ld (bc),a
   
   ret

_ioctl_cls:

   ld a,OTERM_MSG_CLS
   call l_jpix
   
   xor a                       ; clears carry flag
   
   ld (ix+20),a                ; set scroll_limit to zero
   
   ld l,a
   ld h,a
   
   ld (ix+14),l
   ld (ix+15),h

   ret

_ioctl_getset_window_coord:

   ; e & $80 = 1 for get
   ; bc = first parameter (x coord info)
   ; hl = void *arg
   
   ld a,e
   call __stdio_nextarg_hl     ; hl = y coord info
   
   add a,a
   jr c, _ioctl_get_window_coord

_ioctl_set_window_coord:

   ld a,c                      ; a = x coord
   ld (ix+16),a                ; set window.x
   
   ld a,l                      ; a = y coord
   ld (ix+18),a                ; set window.y
   
   ret

_ioctl_get_window_coord:

   ld a,(ix+16)                ; a = window.x

   ld (bc),a
   inc bc
   
   xor a
   ld (bc),a
   
   inc hl
   ld (hl),a
   
   ld a,(ix+18)                ; a = window.y
   
   dec hl
   ld (hl),a
   
   ret

_ioctl_getset_window_rect:

   ; e & $80 = 1 for get
   ; bc = first parameter (rect *)
   ; hl = void *arg

   ld a,e                      ; a = get/set
   
   ld hl,16
   call l_offset_ix_de         ; hl = terminal.window *
   
   ld e,c
   ld d,b                      ; de = rect *
   
   ld bc,4                     ; bc = sizeof(rect)
   
   add a,a
   jr c, _ioctl_get_window_rect

_ioctl_set_window_rect:

   ex de,hl

_ioctl_get_window_rect:

   ldir
   
   or a
   ret

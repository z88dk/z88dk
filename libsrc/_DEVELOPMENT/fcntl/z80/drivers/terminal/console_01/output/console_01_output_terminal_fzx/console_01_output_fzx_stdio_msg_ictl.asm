
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_fzx_stdio_msg_ictl
PUBLIC console_01_output_fzx_stdio_msg_ictl_0

EXTERN OTERM_MSG_CLS

EXTERN error_einval_zc, __stdio_nextarg_hl, l_mulu_16_16x8
EXTERN asm_vioctl_driver, l_offset_ix_de, l_jpix
EXTERN console_01_output_char_stdio_msg_ictl_0
EXTERN console_01_output_fzx_proc_line_spacing_p
EXTERN console_01_output_fzx_proc_putchar_scroll

console_01_output_fzx_stdio_msg_ictl:

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
   ; defc IOCTL_OTERM_FONT             = $0802
   ;
   ; defc IOCTL_OTERM_FZX_GET_PAPER_COORD = $0a82
   ; defc IOCTL_OTERM_FZX_SET_PAPER_COORD = $0a02
   ; defc IOCTL_OTERM_FZX_GET_PAPER_RECT  = $0b82
   ; defc IOCTL_OTERM_FZX_SET_PAPER_RECT  = $0b02
   ; defc IOCTL_OTERM_FZX_LEFT_MARGIN     = $0c02
   ; defc IOCTL_OTERM_FZX_LINE_SPACING    = $0d02
   ; defc IOCTL_OTERM_FZX_SPACE_EXPAND    = $0e02
   ; defc IOCTL_OTERM_FZX_GET_FZX_STATE   = $0f82
   ; defc IOCTL_OTERM_FZX_SET_FZX_STATE   = $0f02
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

console_01_output_fzx_stdio_msg_ictl_0:

   ld a,d
   
   dec a
   jp z, _ioctl_cls
   
   sub $04
   jp z, _ioctl_getset_cursor_coord
   
   sub $02
   jp z, _ioctl_scroll
   
   dec a
   jp z, _ioctl_oterm_font

   sub $02
   jp c, console_01_output_char_stdio_msg_ictl_0
   
   jr z, _ioctl_getset_paper_coord
   
   dec a
   jr z, _ioctl_getset_paper_rect
   
   dec a
   jr z, _ioctl_left_margin
   
   dec a
   jr z, _ioctl_line_spacing
   
   dec a
   jr z, _ioctl_space_expand
   
   dec a
   jp nz, error_einval_zc

_ioctl_getset_fzx_state:

   ; e & $80 = 1 for get
   ; bc = first parameter (struct fzx_state *)
   
   ld a,e                      ; a = get/set
   
   ld hl,30
   call l_offset_ix_de         ; hl = terminal.fzx_state *

   ld e,c
   ld d,b                      ; de = struct fzx_state *
   
   ld bc,22                    ; bc = sizeof(struct fzx_state)

_getset_general:

   add a,a
   jr c, _ioctl_get_fzx_state

_ioctl_set_fzx_state:

   ex de,hl

_ioctl_get_fzx_state:

   ldir
   
   or a
   ret

_ioctl_space_expand:

   ; bc = space_expand
   
   ld l,(ix+49)
   ld h,0                      ; hl = old space_expand
   
   ld a,b
   and c
   inc a
   ret z                       ; if space_expand == -1
   
   ld (ix+49),c
   ret

_ioctl_line_spacing:

   ; bc = line_spacing (0,1,2)
   
   ld l,(ix+21)
   ld h,0                      ; hl = old line spacing
   
   ld a,b
   and c
   inc a
   ret z                       ; if line_spacing == -1
   
   ld (ix+21),c
   ret

_ioctl_left_margin:

   ; bc = left_margin
   
   ld l,(ix+47)
   ld h,(ix+48)                ; hl = old left margin
   
   ld a,b
   and c
   inc a
   ret z                       ; if left_margin = -1
   
   ld (ix+47),c
   ld (ix+48),b                ; set new left_margin
   
   ret

_ioctl_getset_paper_rect:

   ; e & $80 = 1 for get
   ; bc = first parameter (struct r_Rect16 *)

   ld a,e                      ; a = get/set
   
   ld hl,39
   call l_offset_ix_de         ; hl = terminal.paper *
   
   ld e,c
   ld d,b                      ; de = struct r_Rect16 *
   
   ld bc,8                     ; bc = sizeof(struct r_Rect16)

   jr _getset_general

_ioctl_getset_paper_coord:

   ; e & $80 = 1 for get
   ; bc = first parameter (x coord)
   ; hl = void *arg
   
   ld a,e                      ; a = get/set
   call __stdio_nextarg_hl     ; hl = y coord
   
   add a,a
   jr c, _ioctl_get_paper_coord

_ioctl_set_paper_coord:

   ld (ix+39),c
   ld (ix+40),b                ; set paper.x
   
   ld (ix+43),l
   ld (ix+44),h                ; set paper.y
   
   ret

_ioctl_get_paper_coord:

   ld a,(ix+39)
   ld (bc),a
   inc bc
   ld a,(ix+40)
   ld (bc),a                   ; copy paper.x
   
   ld a,(ix+43)
   ld (hl),a
   inc hl
   ld a,(ix+44)
   ld (hl),a                   ; copy paper.y
   
   or a
   ret

_ioctl_getset_cursor_coord:

   ; e & $80 = 1 for get
   ; bc = first parameter (x coord)
   ; hl = void *arg

   ld a,e                      ; a = get/set
   call __stdio_nextarg_hl     ; hl = y coord
   
   add a,a
   jr c, _ioctl_get_cursor_coord

_ioctl_set_cursor_coord:

   ld (ix+35),c
   ld (ix+36),b                ; set terminal.x
   
   ld (ix+37),l
   ld (ix+38),h                ; set terminal.y
   
   ret

_ioctl_get_cursor_coord:

   ld a,(ix+35)
   ld (bc),a
   inc bc
   ld a,(ix+36)
   ld (bc),a
   
   ld a,(ix+37)
   ld (hl),a
   inc hl
   ld a,(ix+38)
   ld (hl),a
   
   or a
   ret

_ioctl_oterm_font:

   ; bc = first parameter (font address)
   ; hl = void *arg
   
   ld hl,33
   call l_offset_ix_de
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = old struct fzx_font *

   ld a,b
   and c
   inc a
   jr z, _ioctl_font_ret       ; if font == -1

   ld (hl),b
   dec hl
   ld (hl),c

_ioctl_font_ret:

   ex de,hl                    ; hl = old font address
   ret
   
_ioctl_cls:

   ld a,OTERM_MSG_CLS
   call l_jpix
   
   xor a                       ; clears carry flag
   
   ld (ix+20),a                ; set scroll_limit to zero
   
   ld l,a
   ld h,a
   
   ld (ix+35),l
   ld (ix+36),h                ; x = 0
   
   ld (ix+37),l
   ld (ix+38),h                ; y = 0
   
   ret

_ioctl_scroll:

   ; bc = first parameter (number of rows to scroll)
   ; each row has height equal to the selected font's height
   
   ld l,(ix+33)
   ld h,(ix+34)                ; hl = struct fzx_font *
   
   ld l,(hl)
   ld h,0                      ; hl = font height in pixels
   
   ld e,l
   ld d,h                      ; de = font height in pixels
   
   ld a,(ix+21)                ; a = line_spacing
   
   call console_01_output_fzx_proc_line_spacing_p
   
   ; hl = number of pixels to scroll per row
   ;  c = number of rows to scroll
   
   ld e,c
   call l_mulu_16_16x8
   
   ; hl = number of pixels to scroll
   
   call console_01_output_fzx_proc_putchar_scroll
   
   or a
   ret

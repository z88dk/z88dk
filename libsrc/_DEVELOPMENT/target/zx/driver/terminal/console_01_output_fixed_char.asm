
INCLUDE "clib_cfg.asm"

SECTION seg_code_fcntl

PUBLIC console_01_output_fixed_char

EXTERN console_01_output_terminal_char
EXTERN 

console_01_output_fixed_char:

   cp ITERM_MSG_PRINT_CURSOR
   jr z, __print_cursor
   
   cp OTERM_MSG_TTY
   jr z, __tty
   
   jp c, console_01_output_terminal_char  ; forward to library
   
   cp OTERM_MSG_PRINTC
   jr z, __printc
   
   cp OTERM_MSG_SCROLL
   jr z, __scroll
   
   cp OTERM_MSG_SCROLL_PAUSE
   jr z, __scroll_pause
   
   cp OTERM_MSG_BELL
   jp nz, console_01_output_terminal_char ; forward to library

   ; fall through to __bell

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__bell:

   ;   can use:  af, bc, de, hl



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_print_cursor:

   ; enter  :  c = cursor char (CHAR_CURSOR_UC or CHAR_CURSOR_LC)
   ; can use: af, bc, de, hl, ix
   
   ; change cursor to flashing 'C' or flashing 'L'
   
   ld a,c
   
   ld c,'C'
   
   cp CHAR_CURSOR_UC
   jr z, cursor

   ld c,'L'

cursor:

   ld b,(ix+23)                ; b = foreground colour
   set 7,b                     ; make it flash

   jp console_01_output_char_oterm_msg_putc_raw

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__tty:

   ;   enter  :  c = char to output
   ;   exit   :  c = char to output (possibly modified)
   ;             carry set if tty emulation absorbs char
   ;   can use:  af, bc, de, hl





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__printc:

   ;   enter  :  c = ascii code >= 32
   ;             b = foreground colour
   ;             l = absolute x coordinate
   ;             h = absolute y coordinate
   ;   can use:  af, bc, de, hl

   call asm_zx_cyx2saddr
   ex de,hl                    ; de = screen coordinates

   ld a,b                      ; a = colour
   
   ld l,c
   ld h,0
   
   add hl,hl
   add hl,hl
   add hl,hl                   ; hl = 8 * ascii code
   
   ld c,(ix+20)
   ld b,(ix+21)                ; bc = font address
   
   add hl,bc                   ; hl = & character definition
   
   ; print character pixels
   
   ld b,7
   ld c,a                      ; c = colour

__print_loop:

   ld a,(hl)
   ld (de),a
   
   inc hl
   inc d
   
   djnz print_loop
   
   ld a,(hl)
   ld (de),a                   ; final pixel row
   
   ex de,hl                    ; hl = screen address at bottom of char
   
   ; put colour
   
   call asm_zx_saddr2aaddr     ; hl = attribute address
   
   ld b,(ix+24)                ; b = foreground colour mask
   
   ld a,b
   cpl
   and c
   ld c,a
   
   ld a,b
   and (hl)
   or c
   ld (hl),a
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__scroll_pause:

   ;   can use:  af, bc, de, hl



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__scroll:

   ;   can use:  af, bc, de, hl



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

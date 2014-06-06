
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fzx output console driver level 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; fzx used to generate console output
; no rom dependency

; FILE *
;
; offset   description
;
;  13,14   driver flags
;  15,16   terminal state *

; terminate state
;
; offset   description
;
;   0,1    input terminal state * (structure in input console)
;   2,3    x coord at start of read line (fzx state)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC cons_output_fzx_L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN __cons_output_terminal_L1, STDIO_MSG_ICTL
   EXTERN STDIO_MSG_OTERM_PUTCHAR, STDIO_MSG_OTERM_L1

cons_output_fzx_L1:

   ; handling PUTC and WRIT messages here would speed things up
   ; but also make things bigger and more complicated for tty emulation
   
   cp STDIO_MSG_OTERM_PUTCHAR
   jr z, __putchar
   
   cp STDIO_MSG_OTERM_L1
   jr z, __oterm_01_t

   cp STDIO_MSG_ICTL
   jp nz, __cons_output_terminal_L1

   ; fall through

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN __cons_output_terminal_L1
   EXTERN _fzx, IOCTL_OTERM_FONT

__ictl:

   ; BC = first parameter
   ; DE = command
   ; HL = void *arg, mind R->L or L->R param order!
   
   ; IOCTL_OTERM_FONT understood here
   
   push hl
   
   ld hl,IOCTL_OTERM_FONT
   sbc hl,de
   
   pop hl
   jp nz, __cons_output_terminal_L1
   
   ; change fzx font
   
   ld hl,(_fzx)                ; hl = old font
   ld (_fzx),bc
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN asm_fzx_putc

__putchar:

   ; these chars are delivered from stdio, not the input console
   ; this is where tty interpretation should be applied

   ; C = char to output
   ;
   ; return carry set on error
   ; can modify af, bc, de, hl

   ld a,c
   
   bit 4,(ix+13)
   jr z, __putchar_raw         ; if cook disabled

__putchar_cook:

   ; interpret special codes here

__putchar_raw:

   ; a = c = char
   
   cp 13
   jr z, __putchar_ok
   
   cp 32
   jr nc, __putchar_ok         ; if ascii code >= 32
   ld c,'?'

__putchar_ok:

   ex af,af'
   push af
   push ix

   ld a,c
   
__echo_loop:

   push af
      
   call asm_fzx_putc
   jr c, __echo_screen_full

   pop af
   pop ix
   pop af
   ex af,af'
   
   or a
   ret

__echo_screen_full:

   call __cons_output_scroll
   
   pop af
   jr __echo_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_L1:

   ; STDIO_MSG_OTERM_L1
   ; b = message number
   ; can modify af, bc, de, hl, ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_01_t:

   djnz __oterm_02_t

__oterm_01:

   ;   b = 1 __cons_output_putc
   ;         c = char to output
   ;         carry set if error (ignored by input console)
   ;         do not modify ix

   ; uses  : all except ix, bc', de', hl'

   ; the input console is generating this output
   ; prevent control characters from being output to driver

   ld a,c
   jr __putchar_raw

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN fzx_mode_xor, _fzx
   EXTERN __fzx_glyph_width, asm_fzx_mode, asm_fzx_putc

__oterm_02_t:

   djnz __oterm_03_t

__oterm_02:

   ;   b = 2 __cons_output_backspace
   ;         c = char to erase
   ;        de = address of char to erase in edit buffer
   ;        carry set if password mode (set locally)

   ; several variations of this were tried
   ;
   ; finally settled on simulating printing of each char
   ; in the edit buffer to find out where the char to
   ; erase is - this makes it easier to do password mode
   ; and will fit in with a level 2 console which allows
   ; text insertion

   push ix                     ; save FILE *
   
   ld a,c
   push af                     ; save erase char
   
   push de                     ; save edit buffer ptr
   
   ld l,(ix+15)
   ld h,(ix+16)                ; hl = terminal state *
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = input console terminal state *
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = initial x coord
   
   ex de,hl                    ; hl = input console terminal state *
   
   inc hl
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = edit buffer address
   
   pop hl                      ; hl = edit buffer ptr
   
   or a
   sbc hl,de                   ; hl = length of edit buffer not including erase char
   
   push hl
   ld l,c
   ld h,b
   pop bc
   
   ld ix,(_fzx)                ; ix = struct fzx_font *

__virtual_print_loop:

   ; ix = struct fzx_font *
   ; de = current edit buffer address
   ; bc = remaining edit buffer length
   ; hl = current x coord
   ; stack = FILE*, erase_char

   ld a,b
   or c
   jr z, __virtual_print_done

   pop af
   push af
   
   jr c, __password_char
   
   ld a,(de)
   inc de

__password_char:

   push bc
   push hl
   
   call __fzx_glyph_width
   
   pop hl

   ld c,a
   ld b,0                      ; bc = char pixel width

   add hl,bc   

   inc h
   dec h
   jr z, __no_wrap
   
   inc l
   dec l

   ld hl,(_fzx+2)
   ld h,b                      ; hl = left margin

   jr z, __no_wrap             ; if char fit exactly in last line
   add hl,bc

__no_wrap:

   pop bc
   
   dec bc
   jr __virtual_print_loop

__virtual_print_done:

   ; ix = struct fzx_font *
   ; hl = x coord of erase_char
   ; stack = FILE*, erase_char
   
   ld de,(_fzx+4)              ; e = current x coord, d = current y coord
   
   ld a,l
   cp e
   ld e,a
   jr c, __erase_char
   
   ; x coord of erased char >= current x coord
   ; need to move up one row

   ld a,d
   sub (ix+0)                  ; subtract font height
   ld d,a
   
   jr nc, __erase_char
   ld d,0

__erase_char:

   ;  e = x coord of erased char
   ;  d = y coord of erased char
   ; stack = FILE*, erase_char
   
   pop hl                      ; h = char to erase
   
   ex af,af'
   push af
   push de                     ; save x,y coord
   
   ld a,h                      ; a = char to erase
   ld (_fzx+4),de              ; set fzx coords

   ld hl,fzx_mode_xor
   call asm_fzx_mode
   
   push hl                     ; save old fzx mode
   call asm_fzx_putc

   pop hl                      ; restore old fzx mode
   call asm_fzx_mode
   
   pop de
   ld (_fzx+4),de
   
   pop af
   ex af,af'
   
   pop ix
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_03_t:

   djnz __oterm_04_t

__oterm_03:

   ;   b = 3 __cons_output_backspace_pwd
   ;         c = password char
   ;        de = address of char to erase in edit buffer

   scf
   jp __oterm_02

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN _fzx

__oterm_04_t:

   dec b
   ret nz                      ; message unknown

__oterm_04:

   ;   b = 4 input console is starting read line
   ;        de = address of edit buffer

   ld l,(ix+15)
   ld h,(ix+16)                ; hl = terminal state *
   
   ld bc,(_fzx+4)              ;  c = current fzx x coordinate
   ld b,0

   inc hl
   inc hl

   ld (hl),c
   inc hl
   ld (hl),b                   ; ts->x = current fzx coord

   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN _cons_attr_p, _fzx
   EXTERN asm0_zx_scroll

__cons_output_scroll:

   ; scroll upward by a number of character rows such that
   ; another line of fzx text can be written
   ;
   ; uses : all except ix, af', bc', de', hl'
   
   ld hl,(_fzx)                ; hl = struct fzx_font *
   ld l,(hl)                   ; l = font height in pixels
   
   ld a,(_fzx+5)               ; a = current y coordinate
   
   add a,l
   sub 192
   ret c                       ; no scroll necessary

   inc a
   ld de,1

__amount_loop:

   sub 8
   jr c, __scroll
   
   inc e
   jr __amount_loop

__scroll:

   ; adjust fzx state
   
   ld a,e
   add a,a
   add a,a
   add a,a
   ld l,a
   
   ld a,(_fzx+5)
   sub l
   ld (_fzx+5),a               ; y coordinate -= E * 8

   ld hl,(_cons_attr_p)
   jp asm0_zx_scroll

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

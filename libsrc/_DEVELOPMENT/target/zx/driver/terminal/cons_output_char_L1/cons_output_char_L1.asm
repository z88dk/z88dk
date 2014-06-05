
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; char output console driver level 1 ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; traditional 8x8 fixed width char output
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
;    2     x coord (0..31) out of range causes wrap
;    3     y coord (0..23) out of range causes scroll
;   4,5    font address
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC cons_output_char_L1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN __cons_output_terminal_L1, STDIO_MSG_ICTL
   EXTERN STDIO_MSG_OTERM_PUTCHAR, STDIO_MSG_OTERM_L1

cons_output_char_L1:

   ; handling PUTC and WRIT messages here would speed things up

   cp STDIO_MSG_OTERM_PUTCHAR
   jr z, __putchar

   cp STDIO_MSG_ICTL
   jr z, __ictl

   cp STDIO_MSG_OTERM_L1
   jp nz, __cons_output_terminal_L1

   ; fall through

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

__oterm_02_t:

   djnz __oterm_03_t

__oterm_02:

   ; backspace:  back up and erase
   ;
   ;   b = 2 __cons_output_backspace
   ;   b = 3 __cons_output_backspace_pwd
   ;         c = char to erase
   ;        de = address of char to erase in edit buffer

   ld l,(ix+15)
   ld h,(ix+16)                ; hl = terminate state *
   
   inc hl
   inc hl

   ld a,(hl)                   ; a = x coord
   inc hl
   
   dec a                       ; back up
   
   cp 32
   jr c, __oterm_x_ok          ; if x coord not off left margin
   
   ld a,31
   dec (hl)                    ; y coord--

__oterm_x_ok:

   ld b,a                      ; b = new x coord
   ld a,(hl)                   ; a = y coord
   
   cp 24
   jr c, __oterm_y_ok          ; if y coord < 24

   xor a
   ld b,a                      ; stop at (0,0)

__oterm_y_ok:

   ; b = new x coord
   ; a = new y coord
   ; hl = & ts->y

   push hl
   
   ld c,32
   call __backspace_helper     ; erase cursor position
   
   pop hl
   
   dec hl
   dec (hl)                    ; decrease x coord

   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_03_t:

   dec b
   jr z, __oterm_02
   ret                         ; other messages don't matter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN IOCTL_OTERM_FONT
   EXTERN __cons_output_terminal_L1

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
   
   ; change font
   
   ld l,(ix+15)
   ld h,(ix+16)                ; hl = terminal state *
   
   inc hl
   inc hl
   inc hl
   inc hl
   
   ld e,(hl)
   ld (hl),c
   inc hl
   ld d,(hl)
   ld (hl),b
   
   ex de,hl                    ; hl = old font
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   EXTERN _cons_attr_p
   EXTERN asm_zx_cyx2saddr, asm_zx_saddr2aaddr, asm0_zx_scroll

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

   ld l,(ix+15)
   ld h,(ix+16)                ; hl = terminate state *
   
   inc hl
   inc hl

   cp 13
   jr z, __crlf                ; if next line

   ld a,(hl)                   ; a = x coord
   inc hl

   cp 32
   jr c, __x_ok                ; if x coord < 32
   
   xor a                       ; x coord = 0
   inc (hl)                    ; y coord++

__x_ok:

   ld b,a                      ; b = new x coord
   ld a,(hl)                   ; a = y coord
   
   cp 24
   jr c, __y_ok                ; if y coord < 24
   
   ; need to scroll
   
   sub 23

   push bc                     ; save b = x coord, c = char
   push hl                     ; save & ts->y
   
   ld e,a
   ld d,0                      ; de = number of rows to scroll upward
   
   ld hl,(_cons_attr_p)        ; l = attribute for cleared rows
   call asm0_zx_scroll
   
   pop hl                      ; hl = & ts->y
   pop bc                      ; b = x coord, c = char
   
   ld a,23                     ; y coord = 23

__backspace_helper:
__y_ok:

   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = & font
   
   dec hl
   dec hl
   
   ld (hl),a                   ; store new y coord
   dec hl
   
   inc b
   ld (hl),b                   ; store next x coord
   dec b
   
   ld l,c
   ld h,0                      ; hl = ascii code
   
   add hl,hl
   add hl,hl
   add hl,hl
   
   add hl,de
   ex de,hl                    ; de = & bitmap
   
   ld l,b                      ; l = x coord
   ld h,a                      ; h = y coord
   
   call asm_zx_cyx2saddr       ; hl = screen address
   
   ld b,8

__glyph_loop:                  ; write glyph

   ld a,(de)
   ld (hl),a
   
   inc h
   inc de
   
   djnz __glyph_loop

   dec h                       ; put screen address back into char
   call asm_zx_saddr2aaddr     ; hl = attribute address

   ld a,(_cons_attr_p)
   ld (hl),a                   ; write attribute
   
   or a
   ret

__crlf:

   ; hl = & ts->x

   xor a
   ld (hl),a                   ; x coord = 0
   
   inc hl
   inc (hl)                    ; y coord++
   
   ld a,(hl)
   cp 24
   ccf
   ret nc                      ; if y < 24
   
   ld (hl),23                  ; y coord = 23
   
   sub 23
   ld e,a
   ld d,0                      ; de = number of rows to scroll upward
   
   ld hl,(_cons_attr_p)        ; l = attribute for cleared rows
   call asm0_zx_scroll

   or a
   ret
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

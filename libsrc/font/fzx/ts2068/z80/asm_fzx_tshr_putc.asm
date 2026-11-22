;; This version does not apply any colour.

; int fzx_tshr_putc(struct fzx_tshr_state *fs, int c)

; ===============================================================
; FZX driver - Copyright (c) 2013 Einar Saukas
; FZX format - Copyright (c) 2013 Andrew Owen
; ===============================================================
; Modified for z88dk - aralbrec
; * removed self-modifying code
; * removed control code sequences
; * added colour and rop modes
; * added window
; * made fields 16-bit for hi-res
; * timex hi-res mode 512x192
; ===============================================================

SECTION code_font
SECTION code_font_fzx

PUBLIC asm_fzx_tshr_putc

EXTERN l_jpix, error_zc
EXTERN asm_tshr_pxy2saddr, asm_tshr_saddrpdown

asm_fzx_tshr_putc:

   ; print fzx glyph to window on screen
   ;
   ; enter :  c = ascii code
   ;         ix = struct fzx_state *
   ;
   ; exit  : ix = struct fzx_state *
   ;
   ;         success
   ;
   ;            hl = screen address below glyph (may be off window)
   ;            fzx_state.x += glyph width
   ;            carry reset
   ;
   ;         fail if glyph does not fit horizontally
   ;
   ;            a = 0
   ;            carry set
   ;
   ;         fail if glyph does not fit vertically
   ;
   ;            a = 1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, af'

   ld l,(ix+3)
   ld h,(ix+4)                 ; hl = struct fzx_font *
   
   ld a,(hl)
   ex af,af'                   ; a' = font height
   
   inc hl
   ld a,(hl)
   push af                     ; save tracking
   
   inc hl                      ; hl = & fzx_font.last_char

   ld a,c                      ; a = char
   dec a
   
   cp (hl)
   jr nc, char_undefined       ; if char > fzx_font.last_char
   
   sub 31                      ; a = char - 32
   jr nc, char_defined

char_undefined:

   ld a,'?'-32                 ; print '?' for undefined chars

char_defined:

   inc hl

   ; hl = struct fzx_char * (code 32)
   ; ix = struct fzx_state *
   ;  a = char-32
   ;  a'= font height
   ; stack = tracking
   
   ld c,a
   ld b,0
   
   add hl,bc
   add hl,bc
   add hl,bc                   ; hl = struct fzx_char *
   
   ; space character can have additional padding
   
   or a
   jr nz, no_padding           ; char not space

   ld a,(ix+19)                ; a = space_expand
   and $0f
   ld b,a

no_padding:

   ld d,b
   
   ; hl = struct fzx_char *
   ; ix = struct fzx_state *
   ;  d = additional_padding
   ;  a'= font height
   ; stack = tracking
   
   ld c,(hl)
   inc hl
   ld a,(hl)
   and $3f
   ld b,a                      ; bc = bitmap offset
   
   xor (hl)
   rlca
   rlca
   ld e,a                      ; e = kern
   
   push hl                     ; save & fzx_char + 1b
   
   add hl,bc
   dec hl                      ; hl = bitmap address
   
   ex (sp),hl
   inc hl                      ; hl = & fzx_char.shift_width_1
   
   ; ix = struct fzx_state *
   ; hl = & fzx_char.shift_width_1
   ;  d = additional_padding
   ;  e = kern
   ;  a'= font height
   ; stack = tracking, & bitmap

   ld a,(hl)
   and $0f
   add a,d
   ld c,a                      ; c = width - 1 + additional_padding
   
   ld a,(hl)
   rra
   rra
   rra
   rra
   and $0f
   push af                     ; save vertical shift

   ; ix = struct fzx_state *
   ; hl = & fzx_char.shift_width_1
   ;  c = width - 1
   ;  e = kern
   ;  a'= font height
   ; stack = tracking, & bitmap, shift
   
   inc hl                      ; hl = & fzx_char.next
   
   ld a,(hl)
   add a,l
   ld b,a                      ; b = LSB of next char bitmap address
   
   ; ix = struct fzx_state *
   ;  b = LSB of end of bitmap
   ;  c = width - 1
   ;  e = kern
   ;  a'= font height
   ; stack = tracking, & bitmap, shift

   ; check if glyph fits window horizontally
   ; timex hi-res is 0-511
   
   ld l,(ix+5)
   ld h,(ix+6)                 ; hl = x coord
   
   ld a,h
   cp 2
   jp nc, x_too_large          ; if x > 511
   
   ld a,l
   sub (ix+17)                 ; subtract left margin
   ld a,h
   sbc (ix+18)
   jr nc, exceeds_margin
   
   ld l,(ix+17)
   ld h,(ix+18)                ; set x = left margin

exceeds_margin:

   xor a
   ld d,a
   
   sbc hl,de                   ; hl = x - kern
   jr nc, x_ok
   
   ld l,a
   ld h,a

x_ok:

   ld (ix+5),l
   ld (ix+6),h                 ; update possibly different x coord

   ld a,c
   add a,l
   ld e,a
   ld a,d
   adc a,h                     ; ae = x + width - 1
   
   cp (ix+12)                  ; compare window.width MSB
   jr c, width_adequate
   jr nz, x_too_large
   
   ld a,e
   cp (ix+11)                  ; compare window.width LSB
   jr nc, x_too_large

width_adequate:

   ld a,(ix+9)
   add a,l
   ld l,a
   ld a,(ix+10)
   adc a,h
   ld h,a                      ; hl += window.x

   ; ix = struct fzx_state *
   ;  b = LSB of end of bitmap
   ;  c = width - 1
   ; hl = absolute x coord
   ;  a'= font height
   ; stack = tracking, & bitmap, shift
   
   ; check if glyph fits window vertically
   
   ld a,(ix+8)
   or a
   jr nz, y_too_large          ; if y > 255
   
   ld e,(ix+7)                 ; e = y coord
   ex af,af'                   ; a = font height
   
   dec a
   add a,e
   jr c, y_too_large           ; if glyph exceeds bottom edge of window

   cp (ix+15)
   jr nc, y_too_large          ; if glyph exceeds bottom edge of window 

height_adequate:
   
   pop af                      ; a = vertical shift
   
   add a,e                     ; + y coord
   add a,(ix+13)               ; + window.y

   ; ix = struct fzx_state *
   ;  b = LSB of end of bitmap
   ;  c = width - 1
   ;  a = absolute y coord
   ; hl = absolute x coord
   ; stack = tracking, & bitmap

   pop de
   push bc
   push de

   push bc

   ld c,a
   call asm_tshr_pxy2saddr     ; hl = screen address, de = x coord
   
   pop bc

   ld a,e
   and $07                     ; a = rotate amount, z = zero rotate

   ex af,af'
   ld e,b

   ex (sp),hl                  ; hl = & bitmap

   ld a,c                      ; a = width - 1
   cp 8
   jr nc, wide_char

narrow_char:

   ex af,af'
   scf
   ex af,af'

wide_char:
   
   ; ix = struct fzx_state *
   ; hl = & bitmap
   ;  e = LSB of end of bitmap
   ; af'= rotate 0-7, carry = narrow char, z = zero rotate
   ; stack = tracking, width - 1, screen address

   ld a,l
   cp e
   jr z, draw_char_ret         ; if bitmap is zero length

draw_char:

   ; ix = struct fzx_state *
   ; hl = & bitmap
   ;  e = LSB of end of bitmap
   ; af'= rotate 0-7, carry = narrow char, z = zero rotate
   ; stack = tracking, width - 1, screen address
   
   ; bitmap bytes
   
   ld d,(hl)                   ; first bitmap byte
   inc hl
   
   ld c,(hl)                   ; second bitmap byte
   inc hl

   xor a                       ; third bitmap byte
   
   ; narrow char test
   
   ex af,af'
   jr nc, rotate_bitmap        ; if wide char
   
   dec hl                      ; no second bitmap byte
   ld c,0                      ; second byte = 0

rotate_bitmap:

   ex (sp),hl                  ; hl = screen address

   jr z, no_rotate

   ld b,a                      ; b = rotate amount
   
   ex af,af'

rotate_loop:

   srl d                       ; rotate bitmap DCA right one pixel
   rr c
   rra
   
   djnz rotate_loop
   
   ex af,af'

no_rotate:

   ex af,af'
   
   ; ix = struct fzx_state *
   ; hl = screen address
   ;  e = LSB of end of bitmap
   ; dca= bitmap bytes
   ; af'= rotate 0-7, carry = narrow char, z = zero rotate
   ; stack = tracking, width - 1, & bitmap

   call l_jpix                 ; call fzx_draw
   call asm_tshr_saddrpdown    ; move screen address down one pixel
   
   ex (sp),hl                  ; hl = & bitmap
   
   ld a,l
   cp e
   jr nz, draw_char

   ; glyph drawn, update x coordinate

   ; ix = struct fzx_state *
   ; stack = tracking, width - 1, screen address

draw_char_ret:

   pop hl                      ; hl = screen address
   pop bc                      ; c = width - 1
   pop af                      ; a = tracking

   inc a
   add a,c
   add a,(ix+5)                ; a = new x coordinate
   
   ld (ix+5),a                 ; store new x coordinate
   ret nc
   inc (ix+6)
   
   or a
   ret

x_too_large:

   ; ix = struct fzx_state *
   ; stack = tracking, & bitmap, shift

   xor a
   jp error_zc - 3

y_too_large:

   ; ix = struct fzx_state *
   ; stack = tracking, & bitmap, shift

   ld a,1
   jp error_zc - 3


; ===============================================================
; FZX driver - Copyright (c) 2013 Einar Saukas
; FZX format - Copyright (c) 2013 Andrew Owen
; Minor Adaptations to z88dk library - aralbrec
; ===============================================================
;
; int fzx_putc(uchar c)
;
; Draw character to screen using current state stored in:
;
; struct fzx_state
; {
;
;  struct fzx_font *font;      // current font
;  uchar            lm;        // left margin in pixels
;  uchar            flags;     // reserved, set to 0 to reset
;  uchar            x;         // current x coordinate in pixels
;  uchar            y;         // current y coordinate in pixels
;
; } fzx;
;
; ===============================================================

SECTION code_font_fzx

PUBLIC asm_fzx_putc

EXTERN _fzx, error_zc, error_onc
EXTERN asm_zx_pxy2saddr, asm_zx_saddrpdown

PUBLIC __fzx_inst_0, __fzx_inst_1, __fzx_inst_2

DEFC FONT = 0
DEFC MARGIN = 2
DEFC P_FLAG = 3
DEFC P_COL = 4
DEFC P_LIN = 5

asm_fzx_putc:

   ; enter :  a = char to print
   ; exit  : hl = number of chars printed (0 or 1)
   ;         carry set if print position is off screen
   ; uses  : af, bc, de, hl, ix, af'
   ;         alters struct_fzx _fzx

   ld hl,_fzx + P_FLAG         ; initial address of local variables
   dec (hl)                    ; expecting a regular character?
   jp m, chk_at                ; branch if yes
   jr z, get_col               ; branch if looking for AT column

get_lin:                       ; a = pixel y coordinate

   inc hl

get_col:
 
   inc hl
   ld (hl),a                   ; write AT coordinate into _fzx structure
   jp error_onc

chk_at:                        ; regular characer in A

   cp 22                       ; AT control code?
   jr nz, chk_cr
   
   ld (hl),2                   ; P_FLAG indicates AT encountered
   jp error_onc

chk_cr:

   inc (hl)                    ; restore previous PFLAG value
   inc hl
   
   ld ix,(_fzx + FONT)         ; current font
   
   cp 13
   jr nz, chk_char
   
   call newline
   jp error_onc
   
chk_char:

   dec a                       ; a = char - 1
   
   cp (ix+2)                   ; compare with font last_char
   jr nc, undef_char
   
   sub 31                      ; a = char - 32
   jr nc, print_char

undef_char:

   ld a,'?'-32                 ; print ? for invalid chars

print_char:

   inc a                       ; a = char - 31

   ld l,a
   ld h,0
   ld d,h
   ld e,l
   add hl,hl
   add hl,de                   ; hl = (char - 31)*3
   
   ld c,ixl
   ld b,ixh
   add hl,bc                   ; hl = & offset_kern in struct_fzx_char
   
   ld e,(hl)
   inc hl
   ld a,(hl)
   and 63
   ld d,a                      ; de = bitmap offset
   
   xor (hl)
   rlca
   rlca
   ld c,a                      ; c = kern
   
   ; ix = struct fzx_font *
   ; hl = & struct fzx_char + 1
   ; de = bitmap offset
   ;  c = kern
   
   push hl
   
   add hl,de
   dec hl                      ; hl = bitmap address
   
   ex (sp),hl                  ; hl = & kern_offset
   inc hl                      ; hl = & shift_width_1
   
   xor a
   rld                         ; a = shift
   
   push af
   
   rld                         ; a = width - 1
   ld (WIDTH1 + 1),a           ; self-modifying code
   
   cp 8                        ; is char width > 8 bits?
   rld                         ; restore shift_width_1
   
   ld de,$000e                 ; self-modifying code "LD C,0"
   jr c, narrow_char
   
   ld de,$234e                 ; self-modifying code "LD C,(HL)" and "INC HL"

narrow_char:

   ld (SMC),de                 ; write some self-modifying code
   
   ; ix = struct fzx_font *
   ; hl = & struct fzx_char + 2
   ;  c = kern
   ; stack = & bitmap, shift in msb
   
   inc hl                      ; hl = & struct fzx_char for next character definition
   ld a,(hl)
   add a,l
   ld e,a
   
   ;  e = LSB of next character bitmap address
   
   ld hl,_fzx + P_COL
   ld a,(_fzx + MARGIN)
   ld b,a
   
   ld a,(hl)                   ; a = current x coordinate
   sub c                       ; move left kern pixels
   jr c, off_screen
   
   cp b
   jr nc, on_screen

off_screen:

   ld a,b                      ; stop at left margin

on_screen:

   ld (hl),a                   ; save current x coordinate
   
   ld a,(WIDTH1 + 1)           ; a = width - 1
   add a,(hl)                  ; a = x + (width - 1)
   call c, newline
   
   ; ix = struct fzx_font *
   ;  e = LSB of next character bitmap address
   ; stack = & bitmap, shift in msb

x_fine:

   ld hl,(_fzx + P_COL)        ; l = x coord, h = y coord
   
   ld a,(ix+0)                 ; a = font height
   add a,h
   
   cp 193                      ; will char draw off screen?
   jp nc, error_zc - 2         ; return 0, carry set, pop two items
   
   pop af                      ; a = vertical shift
   add a,h
   ld h,a
   
   ld a,l
   and $07
   ex af,af'                   ; a' = col % 8
   
   push de
   call asm_zx_pxy2saddr       ; change pixel coord in hl to screen address in hl
   pop de
   
   jr chk_loop
   
main_loop:

   ; ix = struct fzx_font *
   ; hl = & bitmap
   ;  e = LSB of next character bitmap address
   ; a' = horizontal rotation 0-7
   ; stack = screen address

   ld d,(hl)                   ; d = 1st byte from char definition grid
   inc hl

SMC:                           ; target of self-modifying code

   ld c,(hl)                   ; c = 2nd byte from char definition or zero
   inc hl                      ;     (either "LD C,0" or "LD C,(HL); INC HL"

   xor a                       ; a = 3rd zero byte
   
   ex (sp),hl                  ; hl = screen address
   
   ex af,af'                   ; a = x % 8, a' = 0
   jr z, no_rotate
   
   ld b,a                      ; b = x % 8
   ex af,af'

rotate_pixels:

   srl d                       ; rotate bitmap in D,C,A right                  
   rr c
   rra
   djnz rotate_pixels
   
no_rotate:

   ; ix  = struct fzx_font *
   ; hl  = screen address
   ; dca = font pixels 
   ;  e  = LSB of next character bitmap address
   ;  a' = horizontal rotation 0-7
   ; stack = & bitmap

   inc l
   inc l

__fzx_inst_0:
   
   nop
   or (hl)                     ; rightmost byte A to screen
   
   ld (hl),a                   ; (note could be offscreen but ORing zero in that case)
   
   dec l
   ld a,c

__fzx_inst_1:

   nop
   or (hl)
   
   ld (hl),a                   ; second byte C to screen
   
   dec l
   ld a,d

__fzx_inst_2:

   nop
   or (hl)
   
   ld (hl),a                   ; first byte D to screen
   
   call asm_zx_saddrpdown      ; modify screen address in HL to move down one pixel
   
chk_loop:

   ; ix = struct fzx_font *
   ; hl = screen address 
   ;  e = LSB of next character bitmap address
   ; a' = horizontal rotation 0-7
   ; stack = & bitmap

   ex (sp),hl                  ; hl = char bitmap address
   
   ld a,l
   cp e                        ; check if next char bitmap reached
   jr nz, main_loop
   
   pop hl                      ; junk screen address
   
   ld hl,_fzx + P_COL
   ld a,(hl)                   ; a = x coordinate

WIDTH1:                        ; target of self-modifying code

   add a,0                     ; a = x + (width - 1)
   scf
   adc a,(ix+1)                ; a = x + width + tracking
   call c, newline
   
exit:

   ld (hl),a
   jp error_onc

newline:

   ld a,(_fzx + MARGIN)
   ld (hl),a                   ; set x coord to left margin
   
   inc hl
   ld a,(hl)                   ; a = y coord
   add a,(ix+0)                ; a = y + height = next y coord
   ld (hl),a
   ret

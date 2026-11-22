
; ===============================================================
; Aug 2003
; ===============================================================
; 
; void in_mouse_amx_init(uint8_t x_vector, uint8_t y_vector)
;
; Initialize and reset the amx mouse interface.  Place ISRs
; to service the amx mouse interrupts at vectors given.
;
; Technical References:
;
; 1. http://www.breezer.demon.co.uk/spec/tech/hware.html
;    Excerpt of the Z80 Emulator's documentation on the AMX Mouse.
;    Information is incorrect about mouse buttons.  Used the
;    Spectaculator emulator as reference for button behaviour.
;
; 2. "Z80 Data Book," Mostek Microcomputer Corporation, August 1978.
;    Technical documentation for the Z80 PIO Chip.
;
; Port Addresses:
; 
; $1f = PIO data port A
; $3f = PIO data port B
; $5f = PIO control port A
; $7f = PIO control port B
; $df = mouse buttons = LRMX XXXX active low and not debounced
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_mouse_amx_init
PUBLIC asm_in_mouse_amx_reset

EXTERN asm_im2_install_isr

EXTERN __input_amx_mouse_x, __input_amx_mouse_y
EXTERN __input_amx_mouse_dx, __input_amx_mouse_dy

asm_in_mouse_amx_init:

   ; enter : b = im2 vector for X interrupts (even, 0..254)
   ;         c = im2 vector for Y interrupts (even, 0..254)
   ;         note: the PIO chip can only store even vectors
   ;
   ; uses  : af, de, hl
   
   ld l,b
   ld de,AMX_X_ISR
   call asm_im2_install_isr
   
   ld l,c
   ld de,AMX_Y_ISR
   call asm_im2_install_isr
   
   ld a,b
   out ($5f),a                 ; PIO vector for X
   ld a,$97
   out ($5f),a                 ; PIO enable interrupt generation for X
   ld a,$4f
   out ($5f),a                 ; PIO select input mode for X

   ld a,c
   out ($7f),a                 ; PIO vector for Y
   ld a,$97
   out ($7f),a                 ; PIO enable interrupt generation for Y
   ld a,$4f
   out ($7f),a                 ; PIO select input mode for Y

asm_in_mouse_amx_reset:

   ; uses : hl
   
   ld hl,$0100                 ; move one pixel per interrupt
   ld (__input_amx_mouse_dx),hl
   ld (__input_amx_mouse_dy),hl
   
   ld h,l                      ; set mouse coordinate to (0,0)
   ld (__input_amx_mouse_x),hl
   ld (__input_amx_mouse_y),hl
   
   ret


   ; interrupt service routines

AMX_X_ISR:

   push af
   push de
   push hl

   ld de,(__input_amx_mouse_dx)
   ld hl,(__input_amx_mouse_x)

   in a,($1f)
   or a
   jr z, move_right

move_left:
   
   sbc hl,de
   jr nc, continue_x
   
   ld hl,0
   jr continue_x

move_right:

   add hl,de
   jr nc, continue_x
   
   ld hl,$ffff

continue_x:

   ld (__input_amx_mouse_x),hl
   
   pop hl
   pop de
   pop af
   
   ei
   reti


AMX_Y_ISR:

   push af
   push de
   push hl

   ld de,(__input_amx_mouse_dy)
   ld hl,(__input_amx_mouse_y)

   in a,($3f)
   or a
   jr z, move_up

move_down:

   add hl,de
   jr c, adjust_y
   
   ld a,h
   cp 192
   jr c, continue_y

adjust_y:

   ld hl,191*256
   jr continue_y

move_up:

   sbc hl,de
   jr nc, continue_y

   ld hl,0

continue_y:

   ld (__input_amx_mouse_y),hl
   
   pop hl
   pop de
   pop af
   
   ei
   reti

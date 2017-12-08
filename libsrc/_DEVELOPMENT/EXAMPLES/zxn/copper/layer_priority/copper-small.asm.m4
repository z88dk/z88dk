;; COPPER LIST
;; Reduced to fit in 1k for testing.
;; Doing the whole screen will involve streaming instructions to the copper.

;; This is an asm file that is passed through m4 before assembling.

;; To see what m4 does to this file, ask zcc to process it
;;    zcc +zxn -vn -m4 copper-small.asm.m4

include(`z88dk.m4')                ; useful m4 macros

SECTION rodata_user

PUBLIC _copper
PUBLIC _copper_end

EXTERN __REG_SPRITE_LAYER_SYSTEM
EXTERN __RSLS_LAYER_PRIORITY_SUL, __RSLS_LAYER_PRIORITY_SLU

defc _copper_size = _copper_end - _copper

_copper:

   ; There are two hi-res windows (x,width,y,height) = (2,28,2,16) and (32,28,5,16)
   
   ; These are 64x24 character coordinates but the copper operates in 32x24
   ; character coordinates so we want even sizes for the 64-col (x,width) to divide
   ; by two to get exact 32x24 x coordinates to make things easier.
   
   ; To make the timex hi-res display appear on top of the scrolling layer 2
   ; we'll make use of the nextreg layer priorities register 0x15 (__REG_SPRITE_LAYER_SYSTEM)
   ; and have layer 2 on top by default and then ula on top for the hi-res terminals.
   
   cu.wait 260,0                                                    ; wait a short time after vsync in either 50 or 60 Hz modes
   cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU
   
   Z88DK_FOR(`LOOP', eval(3*8), eval(5*8-1),
   `
      ; LINE LOOP

      cu.wait LOOP, 2/2 - 1                                         ; wait for x = 2/2 - 1 start first window
      cu.nop
      cu.nop
      cu.nop
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait LOOP, (2+28)/2                                        ; wait for x=(2+28)/2 end first window
      cu.nop
      cu.nop
      cu.nop
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   ')
   
   ; two windows appear on the same scan line for y char coord in [5,18)
   ; change to ula on top while beam is over either window

   Z88DK_FOR(`LOOP', eval(5*8), eval(7*8-1),
   `
      ; LINE LOOP

      cu.wait LOOP, 2/2 - 1                                         ; wait for x = 2/2 - 1 start first window
      cu.nop
      cu.nop
      cu.nop
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait LOOP, (2+28)/2                                        ; wait for x=(2+28)/2 end first window
      cu.nop
      cu.nop
      cu.nop
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait LOOP, 32/2 - 1                                        ; wait for x = 32/2 - 1 start first window
      cu.nop
      cu.nop
      cu.nop
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait LOOP, (32+28)/2                                       ; wait for x=(32+28)/2 end first window
      cu.nop
      cu.nop
      cu.nop
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   ')

   cu.stop

_copper_end:

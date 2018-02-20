;; COPPER LIST
;; Reduced to fit in 1k for testing.
;; Doing the whole screen will involve streaming instructions to the copper.

;; This is an asm file that is passed through m4 before assembling.

;; To see what m4 does to this file, ask zcc to process it
;;    zcc +zxn -vn -m4 copper-small.asm.m4

                ; useful m4 macros

INCLUDE "config_zxn_private.inc"

SECTION rodata_user

PUBLIC _copper
PUBLIC _copper_end

; Instead of EXTERN use the INCLUDE above to get hold of these
; constants.  There will be a large defc block at the head of the
; output asm but the asm list file will have all the assembled
; bytes all filled in for debugging.  Will return to EXTERN
; once things work on the real Next.

;EXTERN __REG_SPRITE_LAYER_SYSTEM
;EXTERN __RSLS_LAYER_PRIORITY_SUL, __RSLS_LAYER_PRIORITY_SLU

defc _copper_size = _copper_end - _copper

_copper:

   ; There are two hi-res windows (x,width,y,height) = (2,28,2,16) and (32,28,5,16)
   
   ; These are 64x24 character coordinates but the copper operates in 32x24
   ; character coordinates so we want even sizes for the 64-col (x,width) to divide
   ; by two to get exact 32x24 x coordinates to make things easier.
   
   ; To make the timex hi-res display appear on top of the scrolling layer 2
   ; we'll make use of the nextreg layer priorities register 0x15 (__REG_SPRITE_LAYER_SYSTEM)
   ; and have layer 2 on top by default and then ula on top for the hi-res terminals.
   
   ; Layer 2 is on top at start of frame
   
   
      ; LINE 16

      cu.wait 16, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 16, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 17

      cu.wait 17, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 17, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 18

      cu.wait 18, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 18, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 19

      cu.wait 19, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 19, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 20

      cu.wait 20, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 20, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 21

      cu.wait 21, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 21, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 22

      cu.wait 22, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 22, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 23

      cu.wait 23, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 23, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 24

      cu.wait 24, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 24, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 25

      cu.wait 25, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 25, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 26

      cu.wait 26, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 26, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 27

      cu.wait 27, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 27, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 28

      cu.wait 28, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 28, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 29

      cu.wait 29, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 29, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 30

      cu.wait 30, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 30, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 31

      cu.wait 31, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 31, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 32

      cu.wait 32, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 32, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 33

      cu.wait 33, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 33, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 34

      cu.wait 34, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 34, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 35

      cu.wait 35, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 35, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 36

      cu.wait 36, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 36, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 37

      cu.wait 37, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 37, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 38

      cu.wait 38, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 38, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 39

      cu.wait 39, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top

      cu.wait 39, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
   
   ; two windows appear on the same scan line for y char coord in [5,18)
   ; change to ula on top while beam is over either window

   
      ; LINE 40

      cu.wait 40, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 40, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 40, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 40, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 41

      cu.wait 41, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 41, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 41, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 41, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 42

      cu.wait 42, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 42, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 42, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 42, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 43

      cu.wait 43, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 43, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 43, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 43, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 44

      cu.wait 44, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 44, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 44, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 44, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 45

      cu.wait 45, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 45, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 45, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 45, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 46

      cu.wait 46, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 46, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 46, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 46, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 47

      cu.wait 47, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 47, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 47, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 47, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 48

      cu.wait 48, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 48, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 48, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 48, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 49

      cu.wait 49, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 49, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 49, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 49, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 50

      cu.wait 50, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 50, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 50, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 50, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 51

      cu.wait 51, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 51, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 51, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 51, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 52

      cu.wait 52, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 52, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 52, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 52, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 53

      cu.wait 53, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 53, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 53, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 53, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 54

      cu.wait 54, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 54, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 54, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 54, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 55

      cu.wait 55, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 55, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 55, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 55, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 56

      cu.wait 56, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 56, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 56, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 56, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 57

      cu.wait 57, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 57, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 57, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 57, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 58

      cu.wait 58, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 58, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 58, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 58, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 59

      cu.wait 59, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 59, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 59, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 59, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 60

      cu.wait 60, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 60, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 60, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 60, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 61

      cu.wait 61, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 61, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 61, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 61, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 62

      cu.wait 62, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 62, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 62, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 62, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 63

      cu.wait 63, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 63, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 63, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 63, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 64

      cu.wait 64, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 64, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 64, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 64, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 65

      cu.wait 65, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 65, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 65, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 65, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 66

      cu.wait 66, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 66, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 66, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 66, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 67

      cu.wait 67, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 67, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 67, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 67, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 68

      cu.wait 68, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 68, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 68, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 68, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 69

      cu.wait 69, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 69, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 69, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 69, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 70

      cu.wait 70, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 70, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 70, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 70, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 71

      cu.wait 71, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 71, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 71, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 71, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 72

      cu.wait 72, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 72, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 72, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 72, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 73

      cu.wait 73, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 73, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 73, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 73, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 74

      cu.wait 74, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 74, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 74, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 74, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 75

      cu.wait 75, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 75, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 75, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 75, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 76

      cu.wait 76, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 76, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 76, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 76, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 77

      cu.wait 77, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 77, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 77, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 77, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 78

      cu.wait 78, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 78, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 78, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 78, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 79

      cu.wait 79, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 79, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 79, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 79, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 80

      cu.wait 80, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 80, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 80, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 80, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 81

      cu.wait 81, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 81, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 81, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 81, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 82

      cu.wait 82, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 82, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 82, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 82, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 83

      cu.wait 83, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 83, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 83, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 83, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 84

      cu.wait 84, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 84, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 84, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 84, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 85

      cu.wait 85, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 85, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 85, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 85, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 86

      cu.wait 86, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 86, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 86, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 86, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   
      ; LINE 87

      cu.wait 87, 2/2                                             ; wait for x = 2/2 column start of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 87, (2+28)/2                                        ; wait for x=(2+28)/2 column after end of first window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
      
      cu.wait 87, 32/2                                            ; wait for x = 32/2 column start of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SUL  ; ula on top
      
      cu.wait 87, (32+28)/2                                       ; wait for x=(32+28)/2 column after end of second window
      cu.move __REG_SPRITE_LAYER_SYSTEM, __RSLS_LAYER_PRIORITY_SLU  ; layer 2 on top
   

   cu.stop

_copper_end:

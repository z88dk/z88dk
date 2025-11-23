SECTION rodata_user

PUBLIC _font_8x8_bubble

_font_8x8_bubble:

   ; A
	
	defb 0, 0, 0, 0, 0, 0, 0, 0

   ; B - top left
   
   defb %00000000
   defb %00000111
   defb %00001000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000

   ; C - left or right side
   
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000

   ; D - bottom left
   
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00100000
   defb %01001111
   defb %11110000

   ; E - top right
   
   defb %00000000
   defb %11000000
   defb %00100000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000

   ; F - bottom right
   
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00010000
   defb %00100000
   defb %11000000
   defb %00000000

   ; G - top
   
   defb %00000000
   defb %11111111
   defb %00000000
   defb %00000000
   defb %00000000
   defb %00000000
   defb %00000000
   defb %00000000
   
   ; H - bottom

   defb %00000000
   defb %00000000
   defb %00000000
   defb %00000000
   defb %00000000
   defb %00000000
   defb %11111111
   defb %00000000

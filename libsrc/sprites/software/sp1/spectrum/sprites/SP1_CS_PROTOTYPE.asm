
XLIB SP1_CS_PROTOTYPE

.SP1_CS_PROTOTYPE

   defw 0                  ; pointer to next struct sp1_CS in same sprite (big endian)
   defw 0                  ; pointer to struct sp1_update this sprite char is currently drawn in (big endian)
   defb 0                  ; sprite plane
   defb 0                  ; sprite type (bit 7 = 1 if sprite occludes)
   defb $ff                ; attribute mask - part of underlying colour to keep; $ff = keep entire byte
   defb 0                  ; sprite colour - attribute byte ORed into remaining masked portion; $ff/0 combo makes transparent
   defw 0                  ; & struct sp1_ss.draw_code (+8 bytes offset into struct sp1_ss this struct belongs to)

   ; embedded code in struct (will be overlaid depending on sprite type)

   ld hl,0                 ; graphic definition pointer
   ld ix,0                 ; graphic definition pointer for sprite char to left of this one
   call 0                  ; call correct draw function depending on sprite type

   ; end embedded code

   defw 0                  ; next struct sp1_CS.attr_mask in this struct update's sprite list (big endian)
   defw 0                  ; prev struct sp1_CS.next_in_update in this struct update's sprite list (big endian)

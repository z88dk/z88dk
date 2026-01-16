
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_struct_ss_prototype

_sp1_struct_ss_prototype:

   defb 0                  ; initial row coordinate
   defb SP1V_DISPWIDTH     ; initial col coordinate
   defb 1                  ; initial width in chars/tiles
   defb 0                  ; initial height in chars/tiles
   defb 0                  ; initial vertical rotation in pixels
   defb 0                  ; initial horizontal rotation in pixels
   defw 0                  ; initial sprite graphic animation offset

   ; embedded code in struct

   ld a,SP1V_ROTTBL/256    ; MSB of horizontal rotation table to use
   ld bc,0                 ; offset to add to graphic pointers when drawing sprite
   ex de,hl
   jp (hl)

   ; end embedded code

   defw 0                  ; pointer to first struct sp1_CS in sprite (big endian)

   defb 1                  ; initial xthreshold, minimum horizontal rotation in pixels for last column to draw
   defb 1                  ; initial ythreshold, minimum vertical rotation in pixels for last row to draw
   defb 0                  ; initial number of struct sp1_cs cells belonging to this sprite on display
   

      SECTION code_graphics

      SECTION code_clib

      PUBLIC  xorpixel

      EXTERN sety
      EXTERN setx
      EXTERN getpat
      EXTERN __gfx_coords

; in: hl=(x,y)
xorpixel:
      push af
      push bc
      push hl
      ld (__gfx_coords),hl
      call sety
      call getpat
      call setx
      in a,(0x41) ;dummy read
      in a,(0x41) ;read data
      xor b
      call setx ; to prevent automatic increment of lcd driver
      out (0x41),a ;write data
      pop hl
      pop bc
      pop af
      ret

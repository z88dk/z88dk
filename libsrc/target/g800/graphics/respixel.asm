
      SECTION code_graphics

      SECTION code_clib

      PUBLIC  respixel

      EXTERN sety
      EXTERN setx
      EXTERN getpat
      EXTERN __gfx_coords

; in: hl=(x,y)
respixel:
      push af
      push bc
      push hl
      ld (__gfx_coords),hl
      call sety
      call getpat
      ld a,b
      cpl
      ld b,a
      call setx
      in a,(0x41) ;dummy read
      in a,(0x41) ;read data
      and b
      call setx ; to prevent automatic increment of lcd driver
      out (0x41),a ;write data
      pop hl
      pop bc
      pop af
      ret

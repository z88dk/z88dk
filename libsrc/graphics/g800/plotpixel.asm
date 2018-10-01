      SECTION code_clib

      PUBLIC  plotpixel

      EXTERN sety
      EXTERN setx
      EXTERN getpat
      EXTERN last_pos

; in: hl=(x,y)
plotpixel:
      push af
      push bc
      push hl
      ld (last_pos),hl
      call sety
      call getpat
      call setx
      in a,(0x41) ;read data
      or b
      call setx ; to prevent automatic increment of lcd driver
      out (0x41),a ;write data
      pop hl
      pop bc
      pop af
      ret

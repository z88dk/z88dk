      SECTION code_clib

      PUBLIC point
      PUBLIC _point

      EXTERN pointxy

point:
_point:

; in:  hl=x,y
; out: hl [0/1]

      call pointxy

      ld hl,0
      ret z
      inc hl ;hl=1
      ret

      SECTION code_clib

      PUBLIC pointxy

      EXTERN sety
      EXTERN setx
      EXTERN getpat

pointxy:
; in:  hl=x,y
; out: fZ
      push bc

      call sety
      call getpat

      call setx
      in a,(0x41) ;dummy read
      in a,(0x41) ;read data

      and b
      pop bc

      ;cp 0
      ret



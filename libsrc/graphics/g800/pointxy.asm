      SECTION code_clib

      PUBLIC point
      PUBLIC pointxy
      PUBLIC last_pos
      public sety
      public setx
      public getpat

point:
; in:  hl=x,y
; out: hl [0/1]
      push bc

      call sety
      call getpat
      call setx
      in a,(0x41) ;read data

      and b

      pop bc

      ld hl,0
      cp 0
      ret z
      inc hl ;hl=1
      ret

pointxy:
; in:  hl=x,y
; out: fZ
      push bc

      call sety
      call getpat
      call setx
      in a,(0x41) ;read data

      and b
      pop bc

      cp 0
      ret

sety:
; set y position
; in:  l = y position
      ld a,l
      sra a
      sra a
      sra a  ; a=y/8
      and 0x0f
      or 0xb0
      call out40
      ret

; make pattern
; in: l = y position
; out b = pattern
getpat:
      ld a,l
      and 0x07   ;a=y%8
      inc a
      ld b,0x1
loop_shift:
      dec a
      ret z
      sla b
      jp loop_shift

; set x position
setx:
      push af

      ; lower 4bit of x(h)
      ld a,h
      and 0x0F
      call out40

      ; higher 4bit of x(h)
      ld a,h
      sra a
      sra a
      sra a
      sra a
      and 0x0f
      or 0x10
      call out40

      pop af
      ret

; write to lcd driver
out40:
      push af
loop40:
      in a,(0x40)
      and 0x80
      jp nz,loop40
      pop af
      out (0x40),a
      ret

    SECTION         bss_clib

last_pos:
      defb 0,0

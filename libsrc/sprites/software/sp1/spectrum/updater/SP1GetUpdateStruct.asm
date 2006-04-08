
; SP1GetUpdateStruct
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1GetUpdateStruct
XREF SP1V_DISPHEIGHT, SP1V_DISPWIDTH, SP1V_UPDATEARRAY

; Return struct_sp1_update for row,col coordinate given
; 9 * (SP1V_DISPWIDTH * ROW + COL) + SP1V_UPDATEARRAY
;
; enter :  d = row coord
;          e = col coord
; exit  : hl = struct update *
; uses  : af, de, hl

.SP1GetUpdateStruct

   IF SP1V_DISPWIDTH = 16

      ld l,d
      ld h,0
      ld a,d
      ld d,h
      cp SP1V_DISPHEIGHT
      jp c, nohtadj
      dec h

   .nohtadj

      add hl,hl
      add hl,hl
      add hl,hl
      add hl,hl
      ld a,e
      cp SP1V_DISPWIDTH
      jp c, nowiadj
      dec d

   .nowiadj

      add hl,de            ; hl = 16 * ROW + COL
      ld d,h
      ld e,l
      add hl,hl
      add hl,hl
      add hl,hl
      add hl,de            ; hl = 9 * (16 * ROW + COL)
      ld de,SP1V_UPDATEARRAY
      add hl,de

   ELSE IF SP1V_DISPWIDTH = 24

      ld l,d
      ld h,0
      ld a,d
      ld d,h
      cp SP1V_DISPHEIGHT
      jp c, nohtadj
      dec h

   .nohtadj

      add hl,hl
      add hl,hl
      add hl,hl
      push hl
      add hl,hl
      ld a,e
      cp SP1V_DISPWIDTH
      jp c, nowiadj
      dec d

   .nowiadj

      add hl,de
      pop de
      add hl,de            ; hl = 24 * ROW + COL
      ld d,h
      ld e,l
      add hl,hl
      add hl,hl
      add hl,hl
      add hl,de            ; hl = 9 * (24 * ROW + COL)
      ld de,SP1V_UPDATEARRAY
      add hl,de

   ELSE IF SP1V_DISPWIDTH = 32

      ld l,d
      ld h,0
      ld a,d
      ld d,h
      cp SP1V_DISPHEIGHT
      jp c, nohtadj
      dec h

   .nohtadj

      add hl,hl
      add hl,hl
      add hl,hl
      add hl,hl
      add hl,hl
      ld a,e
      cp SP1V_DISPWIDTH
      jp c, nowiadj
      dec d

   .nowiadj

      add hl,de            ; hl = 32 * ROW + COL
      ld d,h
      ld e,l
      add hl,hl
      add hl,hl
      add hl,hl
      add hl,de            ; hl = 9 * (32 * ROW + COL)
      ld de,SP1V_UPDATEARRAY
      add hl,de

   ELSE

      error: need to supply another multiply case to {sp1}/spectrum/updater/SP1GetUpdateStruct.asm

   ENDIF

   ret

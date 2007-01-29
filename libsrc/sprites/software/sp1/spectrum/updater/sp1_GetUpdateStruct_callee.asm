; struct sp1_update __CALLEE__ *sp1_GetUpdateStruct_callee(uchar row, uchar col)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

INCLUDE "customize.asm"

XLIB sp1_GetUpdateStruct_callee
XDEF ASMDISP_SP1_GETUPDATESTRUCT_CALLEE

.sp1_GetUpdateStruct_callee

   pop bc
   pop de
   pop hl
   push bc
   ld d,l

.asmentry

; Return struct_sp1_update for row,col coordinate given
; 10 * (SP1V_DISPWIDTH * ROW + COL) + SP1V_UPDATEARRAY
;
; enter :  d = row coord
;          e = col coord
; exit  : hl = struct update *
; uses  : af, de, hl

.SP1GetUpdateStruct

   IF SP1V_DISPWIDTH=16

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
      add hl,hl
      ld d,h
      le e,l
      add hl,hl
      add hl,hl
      add hl,de            ; hl = 10 * (16 * ROW + COL)
      ld de,SP1V_UPDATEARRAY
      add hl,de

   ENDIF

   IF SP1V_DISPWIDTH=24

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
      add hl,hl
      ld d,h
      ld e,l
      add hl,hl
      add hl,hl
      add hl,de            ; hl = 10 * (24 * ROW + COL)
      ld de,SP1V_UPDATEARRAY
      add hl,de

   ENDIF

   IF SP1V_DISPWIDTH=32

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
      add hl,hl
      ld d,h
      ld e,l
      add hl,hl
      add hl,hl
      add hl,de            ; hl = 10 * (32 * ROW + COL)
      ld de,SP1V_UPDATEARRAY
      add hl,de

   ENDIF

   ret

DEFC ASMDISP_SP1_GETUPDATESTRUCT_CALLEE = asmentry - sp1_GetUpdateStruct_callee

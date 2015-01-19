; struct sp1_update __CALLEE__ *sp1_GetUpdateStruct_callee(uchar row, uchar col)
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

INCLUDE "ts2068hr/customize.asm"

PUBLIC sp1_GetUpdateStruct_callee
PUBLIC ASMDISP_SP1_GETUPDATESTRUCT_CALLEE

.sp1_GetUpdateStruct_callee

   pop hl
   pop de
   ex (sp),hl
   ld d,l

.asmentry

; Return struct_sp1_update for row,col coordinate given
; 9 * (SP1V_DISPWIDTH * ROW + COL) + SP1V_UPDATEARRAY
;
; enter :  d = row coord
;          e = col coord
; exit  : hl = struct update *
; uses  : af, de, hl

.SP1GetUpdateStruct

      ld l,d
      ld h,0
      ld a,d
      ld d,h
      cp SP1V_DISPHEIGHT
      jp c, nohtadj
      dec h

   .nohtadj

   IF SP1V_DISPWIDTH=16

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

   ENDIF

   IF SP1V_DISPWIDTH=24

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

   ENDIF

   IF SP1V_DISPWIDTH=32

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

   ENDIF

   IF SP1V_DISPWIDTH=40
   
      add hl,hl
      add hl,hl
      add hl,hl
      push hl
      add hl,hl
      add hl,hl
      ld a,e
      cp SP1V_DISPWIDTH
      jp c, nowiadj
      dec d
   
   .nowiadj
   
      add hl,de
      pop de
      add hl,de            ; hl = 40 * ROW + COL
   
   ENDIF
   
   IF SP1V_DISPWIDTH=48

      add hl,hl
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
      add hl,de            ; hl = 48 * ROW + COL

   ENDIF
   
   IF SP1V_DISPWIDTH=56
   
      add hl,hl
      add hl,hl
      add hl,hl
      push hl
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
      add hl,de
      pop de
      add hl,de            ; hl = 56 * ROW + COL

   ENDIF
   
   IF SP1V_DISPWIDTH=64

      add hl,hl
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
   
      add hl,de            ; hl = 64 * ROW + COL

   ENDIF

   ld d,h
   ld e,l
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,de               ; hl = 9 * (SP1V_DISPWIDTH * ROW + COL)

   ld de,SP1V_UPDATEARRAY
   add hl,de

   ret

DEFC ASMDISP_SP1_GETUPDATESTRUCT_CALLEE = # asmentry - sp1_GetUpdateStruct_callee

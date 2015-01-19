; void __CALLEE__ sp1_PutSprClr_callee(uchar **sprdest, struct sp1_ap *src, uchar n)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_PutSprClr_callee
PUBLIC ASMDISP_SP1_PUTSPRCLR_CALLEE

.sp1_PutSprClr_callee

   pop hl
   pop bc
   ld b,c
   pop de
   ex (sp),hl

.asmentry

; Colour sprite by writing (mask,attr) pairs into each
; struct_sp1_cs whose addresses are stored in the array
; pointed at by hl.  The array of struct_sp1_cs is
; populated by a call to SP1GetSprClrAddr.
;
; enter :  b = number of colour pairs to copy (size of sprite in tiles)
;         de = struct sp1_ap[] source array of colour pairs
;         hl = array of sprite colour addresses (all point at struct sp1_cs.attr_mask)
; uses  : af, bc, de, hl

.SP1PutSprClr

   ld c,$ff

.loop

   push de
   ld e,(hl)
   inc hl
   ld d,(hl)              ; de = & sp1_cs.attr_mask
   inc hl
   ex (sp),hl             ; hl = struct sp1_ap[]
   ldi                    ; copy mask and attribute into struct sp1_cs
   ldi
   pop de                 ; de = array of sprite colour addresses advanced one entry
   ex de,hl
   djnz loop

   ret

DEFC ASMDISP_SP1_PUTSPRCLR_CALLEE = # asmentry - sp1_PutSprClr_callee

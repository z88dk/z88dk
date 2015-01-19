; void __CALLEE__ sp1_GetSprClrAddr_callee(struct sp1_ss *s, uchar **sprdest)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_GetSprClrAddr_callee
PUBLIC ASMDISP_SP1_GETSPRCLRADDR_CALLEE

EXTERN sp1_IterateSprChar_callee
EXTERN ASMDISP_SP1_ITERATESPRCHAR_CALLEE

.sp1_GetSprClrAddr_callee

   pop hl
   pop de
   ex (sp),hl

.asmentry

; Stores address of attr_mask member in all struct_sp1_cs
; making up a sprite into array passed in.
;
; enter : hl = & struct sp1_ss
;         de = destination array of sprite colour addresses
; uses  : af, bc, de, hl, ix

.SP1GetSprClrAddr

   ld ix,getaddr
   jp sp1_IterateSprChar_callee + ASMDISP_SP1_ITERATESPRCHAR_CALLEE

.getaddr

   ; hl = & struct sp1_cs
   ; de = current position in destination array of sprite colour addresses

   ld bc,6
   add hl,bc
   ex de,hl                    ; de = & struct sp1_cs.attr_mask, hl = address array
   ld (hl),e                   ; store address of sprite tile's colour info into array
   inc hl
   ld (hl),d
   inc hl
   ex de,hl                    ; de = next destination address in array of pointers

   ret

DEFC ASMDISP_SP1_GETSPRCLRADDR_CALLEE = # asmentry - sp1_GetSprClrAddr_callee

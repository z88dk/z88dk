; void __CALLEE__ sp1_InitCharStruct_callee(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane)
; 05.2007 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB sp1_InitCharStruct_callee
XDEF ASMDISP_SP1_INITCHARSTRUCT_CALLEE

LIB sp1_ChangeSprType_callee
XREF ASMDISP_SP1_CHANGESPRTYPE_CALLEE

LIB _sp1_struct_cs_prototype
XREF SP1V_ROTTBL

.sp1_InitCharStruct_callee

   pop hl
   pop bc
   ld a,c
   ex af,af
   pop bc
   pop de
   ld a,e
   pop de
   ex (sp),hl

; enter : a' = plane
;          a = type
;         hl = struct sp1_cs *
;         de = address of sprite draw function
;         bc = graphic
; uses  : af, bc, de, hl, af', bc', de', hl'

.asmentry

   push hl
   exx                         ; first copy prototype struct sp1_cs into sp1_cs
   pop de
   ld hl,_sp1_struct_cs_prototype
   ld bc,24
   ldir
   exx
   
   push bc                     ; save graphic
   push hl                     ; save & sp1_cs
   call sp1_ChangeSprType_callee + ASMDISP_SP1_CHANGESPRTYPE_CALLEE
   pop hl
   
   ld bc,4
   add hl,bc
   ex af,af                    ; a = plane
   ld (hl),a                   ; write plane
   
   add hl,bc
   ld (hl),sp1_ss_embedded % 256
   inc hl
   ld (hl),sp1_ss_embedded / 256

   inc hl
   inc hl
   pop bc                      ; bc = graphic
   ld (hl),c                   ; write graphic
   inc hl
   ld (hl),b

   ret   

.sp1_ss_embedded

   ld a,SP1V_ROTTBL/256 + 8    ; use rotation of four pixels if user selects a non-NR draw function
   ld bc,0
   ex de,hl
   jp (hl)

DEFC ASMDISP_SP1_INITCHARSTRUCT_CALLEE = asmentry - sp1_InitCharStruct_callee

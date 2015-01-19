; void __CALLEE__ sp1_InitCharStruct_callee(struct sp1_cs *cs, void *drawf, uchar type, void *graphic, uchar plane)
; 01.2008 aralbrec, Sprite Pack v3.0
; ts2068 hi-res version

PUBLIC sp1_InitCharStruct_callee
PUBLIC ASMDISP_SP1_INITCHARSTRUCT_CALLEE

EXTERN _sp1_struct_cs_prototype
EXTERN SP1V_ROTTBL

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

   push bc                     ; save graphic
   push de                     ; save draw function

   ex de,hl                    ; de = struct sp1_cs *
   ld hl,_sp1_struct_cs_prototype
   ld bc,22
   ldir                        ; copy prototype struct sp1_cs into sp1_cs

   ld hl,-5
   add hl,de                   ; hl = & sp1_cs.draw + 1b
   pop de
   dec de                      ; de = & last byte of draw function data
   ex de,hl
   
   ldd                         ; copy draw function data into struct sp1_cs
   ldd
   ldd
   dec hl
   dec hl
   dec de
   dec de
   ldd
   ldd
   pop bc                      ; bc = graphic
   ex de,hl
   ld (hl),b
   dec hl
   ld (hl),c
   dec hl
   dec de
   dec de
   ex de,hl
   ldd
   
   ex de,hl                    ; hl = & sp1_cs.ss_draw + 1b
   ld (hl),sp1_ss_embedded / 256
   dec hl
   ld (hl),sp1_ss_embedded % 256
   
   dec hl                      ; hl = & sp1_cs.type
   ld (hl),a                   ; store type
   dec hl
   ex af,af
   ld (hl),a                   ; store plane

   ret   

.sp1_ss_embedded

   ld a,SP1V_ROTTBL/256 + 8    ; use rotation of four pixels if user selects a non-NR draw function
   ld bc,0
   ex de,hl
   jp (hl)

DEFC ASMDISP_SP1_INITCHARSTRUCT_CALLEE = # asmentry - sp1_InitCharStruct_callee

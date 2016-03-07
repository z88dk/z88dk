; char __CALLEE__ *strtok_r_callee(char *s, char *delim, char **last)
; on each call, return next token in s using delimiters from string delim
; 01.2007 aralbrec

SECTION code_clib
PUBLIC strtok_r_callee
PUBLIC _strtok_r_callee
PUBLIC ASMDISP_STRTOK_R_CALLEE

EXTERN strchr_callee
EXTERN ASMDISP_STRCHR_CALLEE

; static data stored here, not ROMable

.strtok_r_callee
._strtok_r_callee

   pop hl     ; ret addr
   pop bc     ; **lasts
   pop de     ; *delim
   ex (sp),hl ; ret addr <> *s
   
   ; enter : de = char *delim
   ;         hl = char *s
   ;         bc = char **last
   ; exit  : token found : hl = ptr, C flag set
   ;         else        : hl = 0, NC flag set
   ; uses  : af, bc, de, hl

.asmentry


   ld a,h
   or l
   jr nz, newstart
   
   ; BC=**lasts -> HL=*lasts
   ;ld hl,(lastpos)
   ld a,(bc)
   ld l,a
   inc bc
   ld a,(bc)
   ld h,a
   dec bc

   or l
   
;   ld a,h
;   or l
   ret z

.newstart

   ex de,hl
   
   ; hl = char *delim
   ; de = char *s
   
   push de
   push bc	; *lasts

.loop

   ld a,(de)
   or a
   jr z, endstring
   
   ld c,a
   push hl
   call strchr_callee + ASMDISP_STRCHR_CALLEE
   pop hl
   jr nc, endtoken
   inc de
   jp loop

.endstring

   ld l,a
   ld h,a
   jr doret

.endtoken

   ex de,hl
   ld (hl),0
   inc hl
   scf

.doret

   ;;ld (lastpos),hl
   ex de,hl
   pop hl	; *lasts
   ;ld h,b
   ;ld l,c
   ld (hl),e
   inc hl
   ld (hl),d

   pop hl	; *s
   ret

;.lastpos
;
;   defw 0

DEFC ASMDISP_STRTOK_R_CALLEE = # asmentry - strtok_r_callee

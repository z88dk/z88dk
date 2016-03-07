; char __CALLEE__ *strsep_callee(char *s, char *delim)
; on each call, return next token in s using delimiters from string delim
; 01.2007 aralbrec

SECTION code_clib
PUBLIC strsep_callee
PUBLIC _strsep_callee
PUBLIC ASMDISP_STRSEP_CALLEE

EXTERN strchr_callee
EXTERN ASMDISP_STRCHR_CALLEE

; 

.strsep_callee
._strsep_callee

   pop hl     ; ret addr
   pop de     ; *delim
   ex (sp),hl ; ret addr <> **s
   
   ; enter : de = char *delim
   ;         hl = char **s
   ; exit  : token found : hl = ptr, C flag set
   ;         else        : hl = 0, NC flag set
   ; uses  : af, c, de, hl

.asmentry
   

;   ld a,h
;   or l
;   jr nz, newstart
   
;   ld hl,(lastpos)
;   ld a,h
;   or l
;   ret z

;.newstart

; keep **s
   push hl
; **s -> *s
   ld	a,(hl)
   inc hl
   ld	h,(hl)
   ld	l,a

   ex de,hl
   
   ; hl = char *delim
   ; de = char *s
   
   push de

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
   ;ld (lastpos),hl
   ;pop hl
   
   ;pop de	; *s
   ;pop hl	; **s
   
   pop de	; original *s
   ex de,hl
   ex (sp),hl ; *s <> **s

   ld (hl),e	; update **s
   inc hl
   ld (hl),d
   ;ex de,hl
   
   pop hl	; *s
   
   ret

;.lastpos
;
;   defw 0

DEFC ASMDISP_STRSEP_CALLEE = # asmentry - strsep_callee

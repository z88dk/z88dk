; char __CALLEE__ *strtok_callee(char *s, char *delim)
; on each call, return next token in s using delimiters from string delim
; 01.2007 aralbrec

XLIB strtok_callee
XDEF ASMDISP_STRTOK_CALLEE

LIB strchr_callee
XREF ASMDISP_STRCHR_CALLEE

; static data stored here, not ROMable

.strtok_callee

   pop af
   pop de
   pop hl
   push af
   
   ; enter : de = char *delim
   ;         hl = char *s
   ; exit  : token found : hl = ptr, C flag set
   ;         else        : hl = 0, NC flag set
   ; uses  : af, c, de, hl

.asmentry

   ld a,h
   or l
   jr nz, newstart
   
   ld hl,(lastpos)
   ld a,h
   or l
   ret z

.newstart

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
   ld (lastpos),hl
   pop hl
   scf
   ret

.endtoken

   ex de,hl
   ld (hl),0
   inc hl
   ld (lastpos),hl
   pop hl
   ret

.lastpos

   defw 0

DEFC ASMDISP_STRTOK_CALLEE = asmentry - strtok_callee

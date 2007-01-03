; char *stricmp(char *s, char *ct)
; a caseless string comparison
; 12.2006 aralbrec

; exit : if s==ct : hl = 0, Z flag set
;        if s<<ct : hl < 0, NC flag set
;        if s>>ct : hl > 0, C flag set
; uses : asm : af, c, de, hl
;          c : af, bc, de, hl

XLIB stricmp
XDEF ASMDISP_STRICMP

.stricmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc

   ; de = char *ct
   ; hl = char *s

.asmentry
.stricmp1

   ld a,(hl)
   inc hl
   call tolower              ; local version, lib function optimized for C not asm
   ld c,a
   ld a,(de)
   inc de
   call tolower
   cp c
   jr nz, different
   or a
   jp nz, stricmp1
   
   ; here strings are equal
   
   ld l,a
   ld h,a
   ret

.different

   ; effectively performed *ct - *cs

   ld h,$80
   ret nc
   dec h
   ret

.tolower

   cp 'A'
   ret c
   cp 'Z'+1
   ret nc
   or $20
   ret

DEFC ASMDISP_STRICMP = asmentry - stricmp

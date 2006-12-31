;/*
; *	int atoi (char *)
; *
; *	Convert ascii string to integer...
; *
; *	equivalent to stroul(ptr,NULL,10)
; *
; *	But this should be shorter...
; *
; *	Almost k&r but not quite..
; *
; *	djm 5/1/2000
; *
; * -----
; * $Id: atoi.asm,v 1.1 2006-12-31 22:13:19 aralbrec Exp $
; *
; */

XLIB atoi
LIB l_neg

; FASTCALL

; enter : hl = char*
; exit  : hl = int result
;         de = & next char to interpret in char*

.atoi

   ld a,(hl)                 ; eat whitespace
   inc hl

   cp 32                     ; inlined isspace
   jr z, atoi
   cp 7
   jr z, atoi
   cp 10
   jr z, atoi
   cp 13
   jr z, atoi

   ; ate up one too many chars, see if it's a sign
   
   cp '+'
   jr z, signdone
   dec hl
   cp '-'
   jr nz, signdone
   inc hl                    ; this is a negative number
   ld de,l_neg               ; sneakily push negatehl on stack
   push de                   ; so it is run on ret
   
.signdone

   ld de,0
   ex de,hl

.loop

   ld a,(de)
   
   sub '0'                   ; inlined isdigit
   ret c
   cp 10
   ret nc
   
   add hl,hl                 ; hl = hl*10
   ld c,l
   ld b,h
   add hl,hl
   add hl,hl
   add hl,bc
   
   add a,l
   ld l,a
   jr nc, noinc
   inc h
   
.noinc

   inc de
   jp loop

; #include <ctype.h>
; #include <stdlib.h>
;
; int atoi(char *s)
; {
;	int sign;
;	int n;
;	unsigned char *ptr;
;
;	ptr=s;
;	while (isspace(*ptr) ) ++ptr;
;
;	sign = (*ptr == '-' ) ? -1 : 1;
;	if (*ptr=='+' || *ptr=='-' ) ++ptr;
;
;	for (n=0; isdigit(*ptr); ++ptr)
;		n = 10*n + (*ptr-'0');
;	return sign*n;
;}
;
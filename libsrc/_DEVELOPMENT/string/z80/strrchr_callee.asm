
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strrchr(const char *s, int c)
;
; Return ptr to last occurrence of c in string s or NULL
; if c is not found.
;
; ===============================================================

XLIB strrchr_callee
XDEF asm_strrchr

LIB __str_locate_nul, l_neg_bc

strrchr_callee:

   pop hl
   pop bc
   ex (sp),hl

asm_strrchr:
   
   ; enter :  c = char c
   ;         hl = char *s
   ;
   ; exit  : 
   ;         found
   ;
   ;           carry reset
   ;           hl = ptr to c
   ;
   ;         not found
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, bc, e, hl
   
   ld e,c
   
   call __str_locate_nul       ; hl points at terminating 0
   call l_neg_bc               ; bc = strlen + 1
   
   ld a,e                      ; a = char
   cpdr                        ; search backwards
   jr nz, not_found

found_char:

   inc hl
   ret

not_found:

   ld l,c
   ld h,b
   
   scf
   ret

   
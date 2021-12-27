
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

SECTION code_clib
SECTION code_string

PUBLIC asm_strrchr

EXTERN __str_locate_nul, l_neg_bc, error_zc

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

IF __CPU_INTEL__ || __CPU_GBZ80__
   EXTERN __z80asm__cpdr
   call __z80asm__cpdr
ELSE
   cpdr                        ; search backwards
ENDIF
   jp NZ,error_zc

found_char:
   inc hl
   ret

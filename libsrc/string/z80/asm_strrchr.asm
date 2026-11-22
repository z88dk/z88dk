
; ===============================================================
; Dec 2013 / Dec 2021 feilipu
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
   
   ld e,c                      ; e = char

   call __str_locate_nul       ; hl points at terminating 0
   call l_neg_bc               ; bc = strlen + 1

   ld a,e                      ; a = char

IF __CPU_INTEL__ || __CPU_GBZ80__

   dec bc
   inc b
   inc c

loop:
   cp (hl)
   ret Z                       ; found character

   dec hl                      ; search backwards

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

   inc hl
   cp (hl)

ELSE
   cpdr                        ; search backwards
ENDIF

   jp NZ,error_zc

   inc hl                      ; found character
   ret

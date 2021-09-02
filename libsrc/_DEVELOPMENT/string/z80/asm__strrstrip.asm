
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *_strrstrip(const char *s)
;
; Return ptr to first whitespace char of the trailing whitespace
; chars in s.
;
; If s consists entirely of whitespace then s is returned.
;
; See also strrstrip() that modifies s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm__strrstrip

EXTERN asm_strlen, asm_isspace

asm__strrstrip:

   ; enter : hl = char *s
   ;
   ; exit  : hl = ptr to first ws char of trailing ws chars in s
   ;         de = char *s
   ;         carry reset if s is entirely whitespace
   ;
   ; uses  : af, bc, de, hl

   ld de,hl                    ; de = char *s

   ; find strlen(s) and terminating NUL

   call asm_strlen
   jp Z, exit                  ; if strlen(s) == 0

   ld bc,hl                    ; bc = strlen(s)

   add hl,de                   ; hl = s + strlen(s)
   dec hl                      ; hl points at last char in s

IF __CPU_8085__
   dec bc
ENDIF

loop:

   ld a,(hl)
   call asm_isspace
   jp C, not_ws
  
IF __CPU_INTEL__ || __CPU_GBZ80__
   dec hl
   dec bc

IF __CPU_8085__
   jp NK,loop
ELSE
   ld a,b
   or c
   jp NZ,loop
ENDIF

ELSE 
   cpd                         ; hl--, bc--
   jp PE, loop
ENDIF
   
all_ws:
exit:

   ld hl,de
   ret

not_ws:

   inc hl                      ; past non-ws char
   ret

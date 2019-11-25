
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t strnlen(const char *s, size_t maxlen)
;
; Return minimum of strlen(s) and maxlen.
; Does not examine more than maxlen chars.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strnlen

EXTERN error_znc

asm_strnlen:

   ; enter: hl = char *s
   ;        bc = maxlen
   ;
   ; exit : hl = min( strlen(s), maxlen )
   ;        de = char *s
   ;        z flag set if hl=min is 0
   ;        carry reset
   ;
   ; uses : af, bc, de, hl

   ld e,l
   ld d,h                      ; de = char *s

   ld a,b
   or c
   jp z, error_znc
   
   xor a
IF __CPU_GBZ80__
   EXTERN __z80asm_cpir
   call __z80asm_cpir
ELSE
   cpir                        ; find end of s, maxlen chars examined
ENDIF

   jr nz, notend               ; if end of s not reached, skip scf
   scf                         ; end of s reached, need to sub 1 extra

notend:

IF __CPU_INTEL__ | __CPU_GBZ80__
   ld  a,l
   sub e
   ld  l,a
   ld  a,h
   sbc d
   ld  h,a
ELSE
   sbc hl,de                   ; hl = min(strlen, maxlen)
ENDIF
   ret

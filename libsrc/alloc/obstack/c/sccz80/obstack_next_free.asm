
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_next_free(struct obstack *ob)
;
; Returns address of next available byte in the obstack.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_next_free

EXTERN asm_obstack_next_free

defc obstack_next_free = asm_obstack_next_free

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _obstack_next_free
defc _obstack_next_free = obstack_next_free
ENDIF


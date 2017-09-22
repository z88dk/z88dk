
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t obstack_room(struct obstack *ob)
;
; Number of free bytes available in the obstack.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_obstack

PUBLIC obstack_room

EXTERN asm_obstack_room

defc obstack_room = asm_obstack_room

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _obstack_room
defc _obstack_room = obstack_room
ENDIF


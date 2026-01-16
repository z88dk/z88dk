; void sp1_Validate(struct sp1_Rect *r)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_Validate

EXTERN _sp1_Validate_fastcall

_sp1_Validate:

   pop af
   pop hl
   
   push hl
   push af

   jp _sp1_Validate_fastcall

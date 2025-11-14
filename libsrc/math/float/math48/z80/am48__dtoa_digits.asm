
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48__dtoa_digits

EXTERN mm48__left

am48__dtoa_digits:

   ; generate decimal digits into buffer
   ;
   ; enter : EXX = mantissa bits, most sig four bits contain decimal digit
   ;           B = number of digits to generate
   ;           C = remaining significant digits
   ;          HL = buffer * (address of next char to write)
   ;
   ; exit  :   B = remaining number of digits to generate
   ;           C = remaining number of significant digits
   ;          HL = buffer * (address of next char to write)
   ;
   ;          carry reset if exhausted significant digits and exit early (C=0, B!=0)
   ;
   ; uses  : af, bc, hl, bc', de', hl'

   ld a,c
   or a
   ret z                       ; if no more significant digits
   
   exx
   
   ld a,b
   rra
   rra
   rra
   rra
   and $0f
   add a,'0'                   ; a = decimal digit
   
   exx
   
   ld (hl),a                   ; write decimal digit
   inc hl
   
   exx
   
   ld a,b
   and $0f
   ld b,a
   
   push bc                     ; BCDEHL *= 10
   push de
   push hl
   sla l
   call mm48__left
   sla l
   call mm48__left
   ex de,hl
   ex (sp),hl
   add hl,de
   pop de
   ex (sp),hl
   adc hl,de
   ex de,hl
   pop hl
   ex (sp),hl
   adc hl,bc
   ld c,l
   ld b,h
   pop hl
   sla l
   call mm48__left

   exx
   
   dec c                       ; significant digits --
   djnz am48__dtoa_digits
   
   scf                         ; indicate all digits output
   ret

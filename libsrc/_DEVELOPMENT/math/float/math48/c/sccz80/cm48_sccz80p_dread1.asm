
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dread1, cm48_sccz80p_dread1b

EXTERN am48_dload, am48_dloadb

   ; read float from address in HL
   ;
   ; enter : hl = double * (math48 format)
   ;
   ; exit  : AC' = double
   ;
   ; uses  : af, bc, de, hl, EXX set active
   
defc cm48_sccz80p_dread1  = am48_dload
defc cm48_sccz80p_dread1b = am48_dloadb


SECTION code_fp_math48

PUBLIC mm48__acpi

mm48__acpi:

;     Set AC equal to PI
;     ------------------
;
;     NAME:      ACPI
;     FUNCTION:  AC=PI. AC is set equal to 3.14159265359.
;     OFFSET:    2DH
;     STACK:     0 bytes.

   ld bc,$490F
   ld de,$DAA2
   ld hl,$2182
   ret

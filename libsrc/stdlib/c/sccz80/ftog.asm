; size_t ftog(float x, char *buf, uint16_t prec, uint16_t flag)
;
; Generic %g fallback: print fixed-point via the linked float library's
; ftoa().  Libraries with a true %g implementation (math32 provides the
; C11 dtoa engine as ftog) override this by defining ftog in their own
; library, which is searched before the classic clib.  For the 6-byte
; and mbf libraries this preserves the historic classic %g == %f
; behaviour exactly.

SECTION code_clib
SECTION code_stdlib

PUBLIC ftog
PUBLIC _ftog

EXTERN ftoa

ftog:
   jp ftoa

defc _ftog = ftog
;============================================================= 
;
; int srr_wait(port,mask,polarity);
;
;    Used to generate tight status port loops
;    If polarity is TRUE (non zero) then the routine returns
;    when (PORT AND MASK) gives a ZERO result
;    (ie when PORT and MASK have NO bits in common)
;    If polarity is FALSE (zero) then the routine returns
;    when (PORT AND MASK) gives a NON ZERO result
;    (ie when PORT and MASK have SOME bits in common)
;    The value returned is data input from the port.
;

SECTION smc_clib

PUBLIC srr_wait
PUBLIC _srr_wait

EXTERN srr_arghak
EXTERN srr_arg1
EXTERN srr_arg2
EXTERN srr_arg3

srr_wait:
_srr_wait:
 
        call    srr_arghak      ;get the parameters
        PUSH    BC
 
        LD     A,(srr_arg1)     ;the port number
        LD     (wait2+1),a      ;I hate self
        LD     (wait4+1),a      ;  modifying
        LD     (wait6+1),a      ;    code!
        LD     A,(srr_arg2)     ;the MASK
        LD     b,a
        LD     A,(srr_arg3)     ;the polarity
        OR     a                ;false polarity ?
        jp     z,wait4          ;yes - jump
wait2:  IN     A,(0)            ;input the port
        AND    b                ;and MASK
        jp     nz,wait2         ;and loop while NZ
        jp     wait6
wait4:  IN     A,(0)            ;input the port
        AND    b                ;and MASK
        jp     z,wait4          ;and loop while Z
wait6:  IN     A,(0)            ;get the port again
        LD     l,a              ;and into HL
        LD     h,0
        POP    BC
        ret

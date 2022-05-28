;   Videoton TV Computer C stub
;   Sandor Vass - 2022
;
;	Set memory map and saves into the P_SAVE shadow
;

	SECTION code_clib
	PUBLIC  tvc_set_memorymap
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        The new memory mapping value
;               The value is stored in P_SAVE ($0003) then OUT to PORT_MMAP ($02)
; CAUTION!!! Interrupts, ROM routines (keyboard, gfx, chr in/out, etc...) works only if U0 remains mapped in PAGE0

;
.tvc_set_memorymap
._tvc_set_memorymap
    ld      a,l
    ld      (P_SAVE),a      ; Store the new value. This is needed for ROM routines. They map SYS to PAGE03 
                            ; but when finished they revert the mapping to the original one stored in P_SAVE.
    OUT     (PORT_MMAP),a   ; Set the mapping
    
	ret

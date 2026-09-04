;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; 8080 sccz80 callee float read (no exx, never pop af for return).
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC cm32_sccz80_fsread1_callee


.cm32_sccz80_fsread1_callee
    pop bc                      ; my return
    pop de                      ; ret1
    pop hl                      ; LSW
    ex de,hl                    ; DE=LSW, HL=ret1
    ex (sp),hl                  ; HL=MSW, (sp)=ret1
    ex de,hl                    ; DE=MSW, HL=LSW
    push bc
    ret

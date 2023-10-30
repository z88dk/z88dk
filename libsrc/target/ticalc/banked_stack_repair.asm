;
; TI calc Routines
;
; Functions called cross-page in multi-page apps have 2 extra elements on the stack, breaking all arguments
; these are the fixes required for entering and existing a function called cross-page
;
        SECTION code_clib
        PUBLIC l_fixup_banked_prologue
        PUBLIC l_fixup_banked_epilogue




l_fixup_banked_prologue:           ;   This should be called before ANYTHING in a bcallable function

        exx
        pop bc   ; Return value for THIS routine


        pop de  ; Return value for the calling routine (Which could be the bcall return handler)

        ld a, d
        cp $2b  ; Test if called from another page

        jp nz,not_from_bcall   ; If not, put back de and return

        ld hl, ($9824) ; Floating Point Stack for storing values
        ld (hl), d
        inc hl
        ld (hl), e
        inc hl
        pop de
        ld (hl), d
        inc hl
        ld (hl), e
        inc hl

        ld ($9824), hl ; put back the incremented Floating Point Stack
        jp from_bcall

not_from_bcall:

        push de

from_bcall:
        push bc ; It would be faster just to jp (hl) or something like that and skip the push and ret
                ; But if we touch any non-shadow registers it will break fastcall functions
        exx
        ret



l_fixup_banked_epilogue:   ; This should be called before the return from a bcallable function (if and only if l_fixup_banked_prologue is called)
        exx

        ld hl, ($9824) ; Floating point stack could be where values were saved
        push hl
        dec hl    
        ld e, (hl)
        dec hl    
        ld d, (hl)
        dec hl    
        ld c, (hl)
        dec hl    
        ld b, (hl)

        ld a, $2b ; Test if starts with bcall return value
        cp a, b

        jp nz, not_returning_to_bcall


        pop af ; Old FPS value
        pop af ; Return value
        push de
        push bc
        push af ; Keep the ret value on top

        jp returning_to_bcall
        



not_returning_to_bcall:

        pop hl;
        ld ($9824), hl;

returning_to_bcall:
        exx
        ret

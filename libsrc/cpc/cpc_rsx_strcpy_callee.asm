;
;       Amstrad CPC library
;       creates a copy of a string in CPC format
;
;       char __LIB__ __CALLEE__ *cpc_rsx_strcpy(char *dst, char *src);
;
;       $Id: cpc_rsx_strcpy_callee.asm,v 1.4 2016-06-10 21:12:36 dom Exp $
;

        SECTION   code_clib
        PUBLIC    cpc_rsx_strcpy_callee
        PUBLIC    _cpc_rsx_strcpy_callee
        PUBLIC    ASMDISP_CPC_RSX_STRCPY_CALLEE
        EXTERN     strlen
        EXTERN     malloc

.cpc_rsx_strcpy_callee
._cpc_rsx_strcpy_callee

   pop hl
   pop de
   ex (sp),hl
   ex  de,hl
   
   ; enter : hl = char *src
   ;         de = char *dst
   ; exit  : hl = char *dst

.asmentry

        push    de      ; cpcstr

        push    hl      ; str ptr

        push    de      ; cpcstr ptr
        call    strlen
        ld	b,h
        ld	c,l
        ld      a,l     ; str len
        pop     hl      ; cpcstr ptr
        
        ld      (hl),a  ; cpc_rsx_str begins with 1 byte for string length
        inc     hl
        ld      d,h
        ld      e,l
        inc     de
        inc     de      ; DE now points to cpc_rsx_str+3
        ld      (hl),e  ; string location (cpc_rsx_str+1)
        inc     hl
        ld      (hl),d
        
        pop     hl      ; str ptr
        
        ldir            ; copy string

        pop     hl      ; cpcstr

        ret

DEFC ASMDISP_CPC_RSX_STRCPY_CALLEE = # asmentry - cpc_rsx_strcpy_callee

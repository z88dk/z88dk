; strncat function for use with far pointers
; 31/3/00 GWL

;
; $Id: strncat_far.asm,v 1.5 2017-01-02 20:37:10 aralbrec Exp $
;
IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_Z180__ && !__CPU_KC160__

    SECTION   code_clib
    SECTION   code_far
    EXTERN __far_start      ; Get the initial bindings
    EXTERN __far_end        ; Reset to initial bindings
    EXTERN __far_page       ; Page in the far segment
    EXTERN l_far_incptrs    ; Increment a far pointer (returning near address)
    PUBLIC  strncatf
    PUBLIC  _strncatf


;far *strncat(far *s1,far *s2,int n)
; concatenates s2 onto the end of s1 (at most n chars) & null-terminates

IF __CPU_RABBIT__
; Rabbit has no ixl, ixh or iyl: IX stays the frame pointer, the counter is the
; argument cell in the frame and a byte kept over a page-in goes on the stack
.strncatf
._strncatf
    push    ix
    ld      ix,4            ; +2 pushed IX +2 return address
    add     ix,sp
    ld      c,(ix+2)
    ld      b,(ix+3)
    ld      e,(ix+4)        ; E'B'C'=s2
    exx
    ld      c,(ix+6)
    ld      b,(ix+7)
    ld      e,(ix+8)        ; EBC=s1
    call    __far_start
    ex      af,af'          ; save seg 1 binding
    call    __far_page      ; start with s1
    jr      startfind
.findend
    call    l_far_incptrs
.startfind
    ld      a,(hl)          ; char from s1
    and     a
    jr      nz,findend
    exx                     ; switch to s2
.catloop
    ld      a,(ix+0)        ; n is the counter in the frame
    or      (ix+1)
    jr      z,strncat2      ; on if copied n chars already
    call    __far_page
    ld      a,(hl)          ; char from s2
    push    af              ; Rabbit has no iyl: keep it on the stack over the page-in
    call    l_far_incptrs
    exx
    call    __far_page
    pop     af
    ld      (hl),a          ; place in s1
    call    l_far_incptrs
    exx
    ld      d,a             ; keep the char over the counter update
    ld      a,(ix+0)
    or      a
    jr      nz,strncat4
    dec     (ix+1)
.strncat4
    dec     (ix+0)
    ld      a,d
    and     a
    jr      nz,catloop
    jr      strncat3
.strncat2
    exx
    call    __far_page
    ld      (hl),0          ; null-terminate s1
.strncat3
    ex      af,af'
    call    __far_end
    ld      l,(ix+6)
    ld      h,(ix+7)
    ld      e,(ix+8)        ; EHL=s1
    pop     ix
    ld      d,0             ; the far pointer returned has d = 0 (__far_page leaves junk in it)
    ret
ELSE
.strncatf
._strncatf
    push    ix              ; preserve caller's IX (80cc fp frame pointer)
    push    iy              ; preserve caller's IY (used as char scratch below)
    ld      ix,6            ; +2 pushed IX +2 pushed IY +2 return address
    add     ix,sp
    ld      c,(ix+2)
    ld      b,(ix+3)
    ld      e,(ix+4)        ; E'B'C'=s2
    exx
    ld      c,(ix+6)
    ld      b,(ix+7)
    ld      e,(ix+8)        ; EBC=s1
    call    __far_start
    ex      af,af'          ; save seg 1 binding
    ld      l,(ix+0)
    ld      h,(ix+1)
    push    ix
    push    hl
    pop     ix              ; IX=n
    call    __far_page      ; start with s1
    jr      startfind
.findend
    call    l_far_incptrs
.startfind
    ld      a,(hl)          ; char from s1
    and     a
    jr      nz,findend
    exx                     ; switch to s2
.catloop
    ld      a,ixl
    or      ixh
    jr      z,strncat2	    ; on if copied n chars already
    call    __far_page
    ld      a,(hl)          ; char from s2
    ld      iyl,a
    call    l_far_incptrs
    exx
    call    __far_page
    ld      a,iyl
    ld      (hl),a          ; place in s1
    call    l_far_incptrs
    exx
    dec     ix
    and     a
    jr      nz,catloop
    jr      strncat3
.strncat2
    exx
    call    __far_page
    ld      (hl),0          ; null-terminate s1
.strncat3
    pop     ix
    ex      af,af'
    call    __far_end
    ld      l,(ix+6)
    ld      h,(ix+7)
    ld      e,(ix+8)        ; EHL=s1
    pop     iy              ; restore caller's IY
    pop     ix              ; restore caller's IX
    ret
ENDIF
ENDIF

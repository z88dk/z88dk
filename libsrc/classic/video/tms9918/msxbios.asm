;
;	z88dk library: Generic VDP support code
;
;	Bouncer to call safely call a remote function, foo variant for Tatung Einstein and similar machines
;
;	$Id: gen_msxbios.asm $
;

    SECTION code_video_vdp

    ; Used by Tatung Einstein, 3 extra bytes only
    PUBLIC  msxbios

msxbios:
    push    ix
    ret

; Mode 3 of the console and graphics (the PC-6001mkII's 320x200,
; MC6847_MODE_MK2: classic/video/mc6847) on the PC-6001, which has no such mode:
; nothing happens (setting the mode fails).
; The PC-6001mkII's library (pc6001mk2.lib, -subtype=mk2disc) is linked first
; and has the real __pc6001mk2_set_attribute.

    SECTION     code_driver
    PUBLIC      __pc6001mk2_set_attribute

__pc6001mk2_set_attribute:
    ret

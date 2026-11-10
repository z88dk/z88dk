;
;    Camputers Lynx 128K: read sectors of the disk
;
;    int lynx_disk_read(uint8_t drive, uint8_t track, uint8_t sector,
;                       uint8_t count, void *buf) __smallc;
;
;    Reads count sectors of 512 bytes into buf, starting at the sector (1 to 10)
;    of the track (the disk is single sided: the track is the cylinder), and
;    carries on to the next track after sector 10.  Returns 0, or 1 if the
;    controller reported an error.  Interrupts are turned off for the call and
;    restored.
;

    MODULE  lynx_disk_read

    SECTION code_clib
    PUBLIC  lynx_disk_read
    PUBLIC  _lynx_disk_read
    PUBLIC  lynx_disk_read_callee
    PUBLIC  _lynx_disk_read_callee

    EXTERN  asm_lynx_disk_call
    EXTERN  asm_lynx_disk_call_callee

lynx_disk_read:
_lynx_disk_read:
    ld      a, 0
    jp      asm_lynx_disk_call

lynx_disk_read_callee:
_lynx_disk_read_callee:
    ld      a, 0
    jp      asm_lynx_disk_call_callee

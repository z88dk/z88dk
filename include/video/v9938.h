

#ifndef __VIDEO_V9938_H__
#define __VIDEO_V9938_H__

#include <sys/compiler.h>

// We want all the good stuff from tms99x8.h
#include <video/tms99x8.h>


typedef enum  {
    /** IMP : destination <- source */
    VDP_CMD_IMP  = 0x00,
    /** AND : destination <- destination & source */
    VDP_CMD_AND  = 0x01,
    /** OR : destination <- destination | source */
    VDP_CMD_OR   = 0x02,
    /** EOR : destination <- destination ^ source */
    VDP_CMD_EOR  = 0x03,
    /** NOT : destination <- ~source */
    VDP_CMD_NOT  = 0x04,
    /** TIMP : destination <- source , if source != 0 */
    VDP_CMD_TIMP = 0x08,
    /** TAND : destination <- destination & source , if source != 0 */
    VDP_CMD_TAND = 0x09,
    /** TOR : destination <- destination | source , if source != 0 */
    VDP_CMD_TOR  = 0x0a,
    /** TEOR : destination <- destination ^ source , if source != 0 */
    VDP_CMD_TEOR = 0x0b,
    /** TNOT : destination <- ~source , if source != 0 */
    VDP_CMD_TNOT = 0x0c,
} vdp_cmd_logic;

typedef enum {
    /**
     * STOP: Stop the running VDP command.
     */
    VDP_CMD_STOP = 0x00,
    /**
     * POINT: Read color code at the given point.
     */
    VDP_CMD_POINT = 0x40,
    /**
     * PSET: Write color code at the given point.
     */
    VDP_CMD_PSET = 0x50,
    /**
     * SRCH: Search color code from the given point towards left/right.
     */
    VDP_CMD_SRCH = 0x60,
    /**
     * LINE: Draw line w/ logical operation.
     */
    VDP_CMD_LINE = 0x70,
    /**
     * LMMV: Fill rectangular area w/ logical operation.
     */
    VDP_CMD_LMMV = 0x80,
    /**
     * LMMM: Copy rectangular area from VRAM to VRAM w/ logical operation.
     */
    VDP_CMD_LMMM = 0x90,
    /**
     * LMCM: VRAM to CPU logical transfer.
     */
    VDP_CMD_LMCM = 0xa0,
    /**
     * LMMC: CPU to VRAM logical transfer.
     */
    VDP_CMD_LMMC = 0xb0,
    /**
     * HMMV: Fill rectangular area.
     */
    VDP_CMD_HMMV = 0xc0,
    /**
     * HMMM: Copy rectangular area from VRAM to VRAM.
     */
    VDP_CMD_HMMM = 0xd0,
    /**
     * YMMM" : Copy rectangular area from VRAM to VRAM vertically.
     */
    VDP_CMD_YMMM = 0xe0,
    /**
     * HMMC" : CPU to VRAM high speed transfer.
     */
    VDP_CMD_HMMC = 0xf0,
} vdp_cmd_operation;


typedef struct {
    uint16_t      sx;       // r32, r33
    uint16_t      sy;       // r34, r35
    uint16_t      dx;       // r36, r37
    uint16_t      dy;       // r38, r39
    uint16_t      nx;       // r40, r41
    uint16_t      ny;       // r42, r43
    uint8_t       clr;      // Colour, r44
    uint8_t       arg;      // 0000b | DIY | DIX | 00b
    uint8_t       cmr;      // op | logop
    uint8_t       wait_finished; // Wait until the operation is finished
} vdp_cmd_t;


// Following this you'll
__ZPROTO3(void,,vdp_cmd_execute,vdp_cmd_t *,cmd,vdp_cmd_operation,oper,vdp_cmd_logic,logic)




#endif

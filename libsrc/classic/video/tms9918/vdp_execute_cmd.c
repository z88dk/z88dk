#include <video/v9938.h>


extern void _v9938_cmd_execute_direct(void *start, int regstart, int num);

void vdp_cmd_execute(vdp_cmd_t *cmd, vdp_cmd_operation oper, vdp_cmd_logic logic)
{
    void    *start = NULL;
    int      count = 0;

    switch ( oper) {
    case VDP_CMD_STOP:    // No others to write
        start = &cmd->cmr;
        break;
    case VDP_CMD_POINT:  // Start from register 32
    case VDP_CMD_SRCH: 
    case VDP_CMD_LMMM:
    case VDP_CMD_LMCM: 
    case VDP_CMD_HMMM:
        count = 14;
        start = &cmd->sx;
        break;
    case VDP_CMD_YMMM:  // Start from register 34
        count = 12;
        start = &cmd->sy;
        break;
    case VDP_CMD_PSET:  // Start from register 36
    case VDP_CMD_LINE:
    case VDP_CMD_LMMV:
    case VDP_CMD_LMMC:
    case VDP_CMD_HMMV:
    case VDP_CMD_HMMC:
        count = 10;
        start = &cmd->dx;
        break;
    }
    cmd->cmr = oper | logic;
    // buf, start reg, number of regs
    _v9938_cmd_execute_direct(start, 46 - count, count);
}
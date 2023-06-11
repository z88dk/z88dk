
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>


int32_t rn_fileHandleSize(uint8_t fileHandle) {

    //0xa4
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FH_SIZE);

    hcca_writeByte(fileHandle);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    return hcca_readInt32();
}

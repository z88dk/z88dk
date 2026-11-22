
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>


int32_t rn_fileSize(uint8_t filenameLen, char *filename) {

    //0xa8
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_SIZE);
    hcca_writeByte(filenameLen);
    hcca_writeBytes(0, filenameLen, filename);

    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);

    return hcca_readInt32();
}

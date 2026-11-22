
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>

void rn_fileHandleCopy(uint8_t srcFilenameLen, uint8_t* srcFilename, uint8_t destFilenameLen, uint8_t* destFilename, uint8_t copyMoveFlag) {

    // 0xae

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_COPY);

    hcca_writeByte(srcFilenameLen);

    hcca_writeBytes(0, srcFilenameLen, srcFilename);

    hcca_writeByte(destFilenameLen);

    hcca_writeBytes(0, destFilenameLen, destFilename);

    hcca_writeByte(copyMoveFlag);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);
    hcca_write_wait_finished();
}

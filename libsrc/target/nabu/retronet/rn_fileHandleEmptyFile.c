
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>

void rn_fileHandleEmptyFile(uint8_t fileHandle) {

    // 0xb0
    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FH_TRUNCATE);

    hcca_writeByte(fileHandle);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);
    hcca_write_wait_finished();
}

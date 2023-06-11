
#include <arch/nabu/retronet.h>
#include <arch/nabu/hcca.h>

#include <stdint.h>
#include <stdio.h>

void rn_fileDelete(uint8_t filenameLen, char *filename) {

  // 0xad

    hcca_reset_write();
    hcca_start_read(HCCA_MODE_RB, NULL, 0);
    hcca_writeByte(RETRONET_CMD_FILE_DELETE);

    hcca_writeByte(filenameLen);

    hcca_writeBytes(0, filenameLen, filename);
    hcca_start_write(HCCA_MODE_BLOCK, NULL, 0);
    hcca_write_wait_finished();
}

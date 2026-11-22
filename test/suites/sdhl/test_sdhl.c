/* The sector waits must keep the caller's HL. A clobber stores the
   sector at (sd_bytes_per_4ms) instead of the buffer and still returns
   success. The multi-block write must take block 2 from buffer+512. */
#include <stdio.h>

extern unsigned int sdhl_run(void);

int main(void)
{
    unsigned int rc;

    rc = sdhl_run();
    if (rc) {
        printf("SDHL_BAD %u\n", rc);
        return 1;
    }
    puts("SDHL_OK");
    return 0;
}

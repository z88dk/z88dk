/* The only float record is a pointer's, which gives no width: -3.25 in the z80 format */
unsigned char gp_buf[6] = { 0x00, 0x00, 0x00, 0x00, 0xd0, 0x82 };
float *gp_ptr = (float *)gp_buf;

int main(void)
{
    return 0;
}

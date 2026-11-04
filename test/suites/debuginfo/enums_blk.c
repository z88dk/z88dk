/* Two blocks of one function declare a local of the same name and different
 * enums: the E: record of each pairs with the S: record of its own block
 * (check_enumblk.sh). sccz80 only: 80cc writes no record for block locals. */
enum colour { RED, GREEN = 5, BLUE };
enum shared { SH_ONE = 1, SH_TWO };
volatile int sink;

int blocks(int in)
{
    {
        enum colour blk = BLUE;
        sink = (int)blk + in;
    }
    {
        enum shared blk = SH_TWO;
        sink = (int)blk + in;       /* <-- check_enumblk.sh BREAK LINE */
    }
    return sink;
}

int main(void)
{
    return blocks(1);
}

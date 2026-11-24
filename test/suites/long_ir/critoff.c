/* Function __critical parameter offset. A CPU that cannot store
   the old enable flag adds no word above the return address. */

static int x;

void critfn(int n) __critical
{
    x = n;
}

int main(void)
{
    critfn(1);
    return x == 1 ? 0 : 1;
}

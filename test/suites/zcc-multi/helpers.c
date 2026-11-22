int a[8];

int sum(void)
{
    int i;
    int s = 0;
    for (i = 0; i < 8; i++)
        s += a[i];
    return s;
}

int main(void)
{
    return sum();
}

int crit_sep(int n)
{
    int s = n;

    __critical { s += 9; }
    return s;
}

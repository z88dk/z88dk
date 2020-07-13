int A=11;
int Q=2;
int L=5;

extern void func(const char *);

void main(void)
{
        if((L+Q*2-3-(A-5))==0) func("It is zero\n");
        else func("It is not zero\n");
}

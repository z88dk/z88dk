

#define XSize 32
extern void func(int);
int main(void)
{
    func(XSize-XSize/4-XSize/5);
    return 0;
}

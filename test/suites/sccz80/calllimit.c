/* 101 arguments. The compiler must diagnose this and stop. */
#define A10 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#define A100 A10, A10, A10, A10, A10, A10, A10, A10, A10, A10

int sink();

int over(void)
{
    return sink(A100, 1);
}


void func(const char *ptr)
{
	char   *callee = ptr;
	char   *me = __func__;
}


int main()
{
	func(__func__);
}



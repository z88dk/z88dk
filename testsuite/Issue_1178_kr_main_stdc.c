
void func(int);
void func2(char *);

main(argc, argv)
int argc;
char **argv;
{
	func(argc);
	func2(argv[1]);
}

func3(int argc, char *argv[])
{
	func(argc);
	func2(argv[1]);
}

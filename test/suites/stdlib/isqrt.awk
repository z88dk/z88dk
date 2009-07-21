BEGIN {
    printf("#include \"stdlib_tests.h\"\n\n");
    for ( i = 0; i < 256; i++ ) {
        printf("void t_sqrt_%d()\n{\n",i);
        printf("    Assert(isqrt(%d) == %d, \"Integer square root of %d should be %d\");\n", i, (sqrt(i)), i, (sqrt(i)));
        printf("}\n\n");
    }
    for ( i = 1023; i < 16384; i+= 223 ) {
        printf("void t_sqrt_%d()\n{\n",i);
#	printf("printf(\"%%d\\n\",isqrt(%d));\n",i);
        printf("    Assert(isqrt(%d) == %d, \"Integer square root of %d should be %d\");\n", i, (sqrt(i)), i, (sqrt(i)));
        printf("}\n\n");
    }

    printf("int test_isqrt()\n{\n");
    printf("    suite_setup(\"isqrt tests\");\n");
    for ( i = 0; i < 256; i++ ) {
        printf("    suite_add_test(t_sqrt_%d);\n",i);
    }
    printf("    return suite_run();\n");
    printf("}\n\n");

    printf("int test_isqrt2()\n{\n");
    printf("    suite_setup(\"isqrt tests - 2\");\n");
    for ( i = 1023; i < 16384; i+= 223 ) {
        printf("    suite_add_test(t_sqrt_%d);\n",i);
    }
    printf("    return suite_run();\n");
    printf("}\n\n");
}

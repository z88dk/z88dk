//-----------------------------------------------------------------------------
// Test util.cpp
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "test.h"
#include "source.h"

#define T_CREATE(data,keep) \
		create_test_file("test.1", data); \
		file = new SourceFile("test.1", keep); \
		OK(file->good())

#define T_READ(nr, text_) \
		line = file->getline(); \
		OK(line != NULL); \
		IS(file->line_nr(), nr); \
		IS(line->line_nr, nr); \
		IS(line->text, text_)

#define T_EOF(nr) \
		line = file->getline(); OK(line == NULL); IS(file->line_nr(), nr); \
		line = file->getline(); OK(line == NULL); IS(file->line_nr(), nr); \
		line = file->getline(); OK(line == NULL); IS(file->line_nr(), nr)

#define T_DELETE() \
	delete file; file = NULL; \
	delete_test_file("test.1")

void test_SourceFile()
{
	SourceFile *file;
	SourceLine *line, *lines[3];

	// empty file
	T_CREATE("", false);

	T_CREATE("", false); 
	T_EOF(0); 
	T_DELETE();

	// file with all new-line types, plus invalid LF-CR
	T_CREATE("f1.asm\n"
			 "f2.asm\r"
			 "f3.asm\r\n"
			 "f4.asm\n\r"
			 "f5.asm", false);

	T_READ(1, "f1.asm");
	T_READ(2, "f2.asm");
	T_READ(3, "f3.asm");
	T_READ(4, "f4.asm");
	T_READ(5, "");
	T_READ(6, "f5.asm");
	T_EOF(6);
	T_DELETE();

	// end file in all new-line types, plus invalid LF-CR
	T_CREATE("f1.asm", false); T_READ(1, "f1.asm"); T_EOF(1); T_DELETE();
	T_CREATE("f1.asm\n", false); T_READ(1, "f1.asm"); T_EOF(1); T_DELETE();
	T_CREATE("f1.asm\r", false); T_READ(1, "f1.asm"); T_EOF(1); T_DELETE();
	T_CREATE("f1.asm\r\n", false); T_READ(1, "f1.asm"); T_EOF(1); T_DELETE();
	T_CREATE("f1.asm\n\r", false); T_READ(1, "f1.asm"); T_READ(2, ""); T_EOF(2); T_DELETE();

	// verify keep_lines
	T_CREATE("1\n2\n3", false);
	T_READ(1, "1"); lines[0] = line;
	T_READ(2, "2"); lines[1] = line;
	T_READ(3, "3"); lines[2] = line;
	T_EOF(3);
	OK(lines[0]->source == file); IS(lines[0]->line_nr, 1); IS(lines[0]->text, "");
	OK(lines[1]->source == file); IS(lines[1]->line_nr, 2); IS(lines[1]->text, "");
	OK(lines[2]->source == file); IS(lines[2]->line_nr, 3); IS(lines[2]->text, "3");
	T_DELETE();

	T_CREATE("1\n2\n3", true);
	T_READ(1, "1"); lines[0] = line;
	T_READ(2, "2"); lines[1] = line;
	T_READ(3, "3"); lines[2] = line;
	T_EOF(3);
	OK(lines[0]->source == file); IS(lines[0]->line_nr, 1); IS(lines[0]->text, "1");
	OK(lines[1]->source == file); IS(lines[1]->line_nr, 2); IS(lines[1]->text, "2");
	OK(lines[2]->source == file); IS(lines[2]->line_nr, 3); IS(lines[2]->text, "3");
	T_DELETE();
}

#undef T_CREATE
#undef T_READ
#undef T_EOF
#undef T_DELETE

void test_SourceStack()
{
	create_test_file("test.1", "11\n12\n13");
	create_test_file("test.2", "21\n22\n23");
	delete_test_file("test.3");

	SourceStack st1(false);
	SourceStack st2(true);

	OK(!st1.has_file("test.1")); OK(!st1.has_file("test.2")); OK(!st1.has_file("test.3")); 
	OK(!st2.has_file("test.1")); OK(!st2.has_file("test.2")); OK(!st2.has_file("test.3")); 

	OK(st1.open("test.1"));
	OK(st2.open("test.1"));

	OK(st1.has_file("test.1")); OK(!st1.has_file("test.2")); OK(!st1.has_file("test.3"));
	OK(st2.has_file("test.1")); OK(!st2.has_file("test.2")); OK(!st2.has_file("test.3"));

	OK(!st1.open("test.4"));
	OK(!st2.open("test.4"));

	OK(st1.has_file("test.1")); OK(!st1.has_file("test.2")); OK(!st1.has_file("test.3"));
	OK(st2.has_file("test.1")); OK(!st2.has_file("test.2")); OK(!st2.has_file("test.3"));

	SourceLine *l1 = st1.getline(); IS(l1->line_nr, 1); IS(l1->text, "11");
	SourceLine *l2 = st2.getline(); IS(l2->line_nr, 1); IS(l2->text, "11");

	OK(st1.open("test.2"));
	OK(st2.open("test.2"));

	OK(st1.has_file("test.1")); OK(st1.has_file("test.2")); OK(!st1.has_file("test.3"));
	OK(st2.has_file("test.1")); OK(st2.has_file("test.2")); OK(!st2.has_file("test.3"));

	l1 = st1.getline(); IS(l1->line_nr, 1); IS(l1->text, "21");
	l2 = st2.getline(); IS(l2->line_nr, 1); IS(l2->text, "21");

	l1 = st1.getline(); IS(l1->line_nr, 2); IS(l1->text, "22");
	l2 = st2.getline(); IS(l2->line_nr, 2); IS(l2->text, "22");

	l1 = st1.getline(); IS(l1->line_nr, 3); IS(l1->text, "23");
	l2 = st2.getline(); IS(l2->line_nr, 3); IS(l2->text, "23");

	l1 = st1.getline(); IS(l1->line_nr, 2); IS(l1->text, "12");
	l2 = st2.getline(); IS(l2->line_nr, 2); IS(l2->text, "12");

	l1 = st1.getline(); IS(l1->line_nr, 3); IS(l1->text, "13");
	l2 = st2.getline(); IS(l2->line_nr, 3); IS(l2->text, "13");

	l1 = st1.getline(); OK(l1 == NULL); l1 = st1.getline(); OK(l1 == NULL); l1 = st1.getline(); OK(l1 == NULL);
	l2 = st2.getline(); OK(l2 == NULL); l2 = st2.getline(); OK(l2 == NULL); l2 = st2.getline(); OK(l2 == NULL);

	delete_test_file("test.1");
	delete_test_file("test.2");
	delete_test_file("test.3");
}

int main()
{
	test_SourceFile();
	test_SourceStack();
	
	done_testing();
	return exit_status();
}

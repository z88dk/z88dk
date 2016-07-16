#define WANT_TEST_EXTRAS
#include <tap++/tap++.h>
#include <stack>
#include <sstream>
#include <cstdlib>
#include <algorithm>

namespace TAP {
  double EPSILON = 1.e-4;

	std::string TODO = "";

	const details::skip_all_type skip_all = details::skip_all_type();
	const details::no_plan_type no_plan = details::no_plan_type();

	namespace {
		unsigned expected = 0;
		unsigned counter = 0;
		unsigned not_oks = 0;

		std::string todo_test() throw() {
			if (TODO == "") {
				return TODO;
			}
			else {
				return " # TODO " + TODO;
			}
		}

		bool is_todo_test() throw() { return TODO != ""; }

		bool is_planned = false;
		bool no_planned = false;
		bool has_output_plan = false;

		void output_plan(unsigned tests, const std::string& extra = "") throw(fatal_exception) {
			if (has_output_plan) {
				throw fatal_exception("Can't plan twice");
			}
			*details::output << "1.." << tests << extra << std::endl;
			has_output_plan = true;
		}
		inline const std::string to_string(unsigned num) throw() {
			std::stringstream out;
			out << num;
			return out.str();
		}

		inline void _done_testing(unsigned tests) throw(fatal_exception) {
			static bool is_done = false;
			if (is_done) {
				fail("done_testing() was already called");
				return;
			}
			is_done = true;

			if (expected && tests != expected) {
				fail(std::string("planned to run ") + to_string(expected) + " tests but done_testing() expects " + to_string(tests));
			}
			else {
				expected = tests;
			}
			is_planned = true;
			if (!has_output_plan) {
				output_plan(tests);
			}
		}

	}

	void plan(unsigned tests) throw(fatal_exception) {
		if (is_planned) {
			bail_out("Can't plan again!");
		}
		is_planned = true;
		output_plan(tests);
		expected = tests;
	}
	void plan(const details::skip_all_type&, const std::string& reason) throw(fatal_exception) {
		output_plan(0, " #skip " + reason);
		std::exit(0);
	}
	void plan(const details::no_plan_type&) throw() {
		is_planned = true;
		no_planned = true;
	}

	void done_testing() throw(fatal_exception) {
		_done_testing(encountered());
	}

	void done_testing(unsigned tests) throw(fatal_exception) {
		no_planned = false;
		_done_testing(tests);
	}

	unsigned planned() throw() {
		return expected;
	}
	unsigned encountered() throw() {
		return counter;
	}

	int exit_status() throw () {
//		bool passing;
		if (!is_planned && encountered()) {
			diag("Tests were run but no plan was declared and done_testing() was not seen.");
		}
		if (no_planned) {
			output_plan(encountered());
			return std::min(254u, not_oks);
		}
		else if (expected == counter) {
			return std::min(254u, not_oks);
		}
		else {
			return 255;
		}
	}
	bool summary() throw() {
		return (not_oks != 0);
	}

	void bail_out(const std::string& reason) throw() {
		*details::output << "Bail out!  " << reason << std::endl;
		std::exit(255); // Does not unwind stack!
	}

	bool ok(bool is_ok, const std::string& message) throw() {
		const char* hot_or_not = is_ok ? "" : "not ";
		*details::output << hot_or_not << "ok " << ++counter<< " - " << message << todo_test()  << std::endl;
		if (!is_ok && !is_todo_test()) {
			++not_oks;
		}
		return is_ok;
	}
	bool not_ok(bool is_not_ok, const std::string& message) throw() {
		return !ok(!is_not_ok, message);
	}

	bool pass(const std::string& message) throw() {
		return ok(true, message);
	}
	bool fail(const std::string& message) throw() {
		return ok(false, message);
	}

	void skip(unsigned num, const std::string& reason) throw ()  {
		for(unsigned i = 0; i < num; ++i) {
			pass(" # skip " + reason);
		}
	}

	void set_output(std::ostream& new_output) throw (fatal_exception) {
		if (is_planned) {
			throw fatal_exception("Can't set output after plan()");
		}
		details::output = &new_output;
	}
	void set_error(std::ostream& new_error) throw(fatal_exception) {
		if (is_planned) {
			throw fatal_exception("Can't set error after plan()");
		}
		details::error = &new_error;
	}
	todo_guard::todo_guard() throw() : value(TODO) {
	}
	todo_guard::~todo_guard() throw() {
		TODO = value;
	}
	namespace details {
		std::ostream* output = &std::cout;
		std::ostream* error = &std::cout;
		static std::stack<unsigned> block_expected;
		void start_block(unsigned expected) throw() {
			block_expected.push(encountered() + expected);
		}
		unsigned stop_block() throw(fatal_exception) {
			unsigned ret = block_expected.top();
			block_expected.pop();
			return ret;
		}

	 	char const * failed_test_msg() throw() {
		     return is_todo_test()?"Failed (TODO) test":"Failed test";
		}

	}

	void skip(const std::string& reason) throw(details::Skip_exception) {
		throw details::Skip_exception(reason);
	}
	void skip_todo(const std::string& reason) throw(details::Todo_exception) {
		throw details::Todo_exception(reason);
	}

}

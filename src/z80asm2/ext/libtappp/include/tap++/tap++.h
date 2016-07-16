#ifndef LIB_TAPPP_TAPPP_H
#define LIB_TAPPP_TAPPP_H

#include <iostream>
#include <string>
#include <cmath>
#include <functional>
#include <limits>

#ifdef _MSC_VER
#pragma warning( disable : 4290 ) // MSVC: https://msdn.microsoft.com/en-us/library/sa28fef8.aspx
#endif

namespace TAP {
	namespace details {
		struct skip_all_type {};
		struct no_plan_type {};
		extern std::ostream* output;
		extern std::ostream* error;

		/* Return the variant of "Failed test" or "Failed                   */
		/* (TODO) test" required by whether the current test is a todo test */
		char const * failed_test_msg() throw();
	}
	class fatal_exception : public std::exception {
		std::string message;
		public:
		fatal_exception(const std::string& _message) : message(_message) {
		}
		const char* what() const throw() {
			return message.c_str();
		}
		~fatal_exception() throw() {
		}
	};
	extern const details::skip_all_type skip_all;
	extern const details::no_plan_type no_plan;
	void plan(unsigned) throw(fatal_exception);
	void plan(const details::skip_all_type&, const std::string& = "") throw(fatal_exception);
	void plan(const details::no_plan_type&) throw();
	void done_testing() throw(fatal_exception);
	void done_testing(unsigned) throw(fatal_exception);

	unsigned planned() throw();
	unsigned encountered() throw();

	bool ok(bool, const std::string& = "") throw();
	bool not_ok(bool, const std::string& = "") throw();

	bool pass(const std::string& = "") throw();
	bool fail(const std::string& = "") throw();

	void skip(unsigned, const std::string& = "") throw();
	void bail_out(const std::string& reason) throw();

	int exit_status() throw();
	bool summary() throw();

	void set_output(std::ostream&) throw(fatal_exception);
	void set_error(std::ostream&) throw(fatal_exception);

	template<typename T> void diag(const T& first) throw() {
		*details::error << "# " << first << std::endl;
	}
	template<typename T1, typename T2> void diag(const T1& first, const T2& second) throw() {
		*details::error << "# " << first << second << std::endl;
	}
	template<typename T1, typename T2, typename T3> void diag(const T1& first, const T2& second, const T3& third) throw() {
		*details::error << "# " << first << second << third << std::endl;
	}
	template<typename T1, typename T2, typename T3, typename T4> void diag(const T1& first, const T2& second, const T3& third, const T4& fourth) throw() {
		*details::error << "# " << first << second << third << fourth << std::endl;
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5> void diag(const T1& first, const T2& second, const T3& third, const T4& fourth, const T5& fifth) throw() {
		*details::error << "# " << first << second << third << fourth << fifth << std::endl;
	}

	template<typename T> void note(const T& first) throw() {
		*details::output << "# " << first << std::endl;
	}
	template<typename T1, typename T2> void note(const T1& first, const T2& second) throw() {
		*details::output << "# " << first << second << std::endl;
	}
	template<typename T1, typename T2, typename T3> void note(const T1& first, const T2& second, const T3& third) throw() {
		*details::output << "# " << first << second << third << std::endl;
	}
	template<typename T1, typename T2, typename T3, typename T4> void note(const T1& first, const T2& second, const T3& third, const T4& fourth) throw() {
		*details::output << "# " << first << second << third << fourth << std::endl;
	}
	template<typename T1, typename T2, typename T3, typename T4, typename T5> void note(const T1& first, const T2& second, const T3& third, const T4& fourth, const T5& fifth) throw() {
		*details::output << "# " << first << second << third << fourth << fifth << std::endl;
	}

	template<typename T, typename U, typename BinaryPredicate> 
	bool is(const T& left, const U& right, const std::string& message, BinaryPredicate p) {
		using namespace TAP::details;
		try {
			bool ret = ok(p(left, right), message);
			if (!ret) {
				diag(failed_test_msg()," '", message, "'");
				diag("       Got: ", left);
				diag("  Expected: ", right);
			}
			return ret;
		}
		catch(const std::exception& e) {
			fail(message);
			diag(failed_test_msg()," '", message, "'");
			diag("Caught exception '", e.what(), "'");
			diag("       Got: ", left);
			diag("  Expected: ", right);
			return false;
		}
		catch(...) {
			fail(message);
			diag(failed_test_msg()," '", message, "'");
			diag("Caught unknown exception");
			diag("       Got: ", left);
			diag("  Expected: ", right);
			return false;
		}
	}

	template<typename T, typename U>
	bool is(const T& left, const U& right, const std::string& message = "") {
		return is(left, right, message, std::equal_to<T>());
	}

	template<typename T, typename U, typename BinaryPredicate> 
	bool isnt(const T& left, const U& right, const std::string& message, BinaryPredicate p) {
		using namespace TAP::details;
		try {
			return ok(!p(left, right), message);
		}
		catch(const std::exception& e) {
			fail(message);
			diag("In test ", message);
			diag("Caught exception: ", e.what());
			return false;
		}
		catch(...) {
			fail(message);
			diag("In test ", message);
			diag("Caught unknown exception");
			return false;
		}
	}

	template<typename T, typename U>
	bool isnt(const T& left, const U& right, const std::string& message = "") {
		return isnt(left, right, message, std::equal_to<T>());
	}

  extern double EPSILON;

  /***
   * Compare two floating point numbers for (nearly) equality. 
   * Follows the floating point guide at
   * http://floating-point-gui.de/errors/comparison/ 
   *
   * RESULT is dependend on EPSILON, which describes the relative error
   */
  template<typename T> 
  struct nearly_equal
  {
  	bool operator()(const T& left, const T& right) const
	  {
	    T diff = fabs(left - right);
	  	return // Shortcut for equality and infinites
	  				 ( left == right ) || 
	  				 // Very small numbers or very small diff
	  				 // (std::numeric_limits<T>::min() gives the smallest normalized number)
	    			 ( (left == 0 || right == 0 || diff < std::numeric_limits<T>::min()) && 
	             diff < EPSILON * std::numeric_limits<T>::min() ) ||
	    			 // relative error
	           ( 2. * diff / fmin(fabs(left) + fabs(right), std::numeric_limits<T>::max()) < EPSILON );
	  }
	};

	template<> inline bool is<float, float>(const float& left, const float& right, const std::string& message) {
  	return is(left, right, message, nearly_equal<float>());
  }

	template<> inline bool is<float, double>(const float& left, const double& right, const std::string& message) {
  	return is(left, right, message, nearly_equal<double>());
  }

	template<> inline bool is<double, float>(const double& left, const float& right, const std::string& message) {
  	return is(left, right, message, nearly_equal<double>());
  }

	template<> inline bool is<double, double>(const double& left, const double& right, const std::string& message) {
  	return is(left, right, message, nearly_equal<double>());
  }

	template<> inline bool isnt<float, float>(const float& left, const float& right, const std::string& message) {
  	return isnt(left, right, message, nearly_equal<float>());
  }

	template<> inline bool isnt<float, double>(const float& left, const double& right, const std::string& message) {
  	return isnt(left, right, message, nearly_equal<double>());
  }

	template<> inline bool isnt<double, float>(const double& left, const float& right, const std::string& message) {
  	return isnt(left, right, message, nearly_equal<double>());
  }

	template<> inline bool isnt<double, double>(const double& left, const double& right, const std::string& message) {
  	return isnt(left, right, message, nearly_equal<double>());
  }

	inline bool is(const float& left, const float& right){
		return is(left, right, "");
	}

	inline bool is(const float& left, const double& right){
		return is(left, right, "");
	}

	inline bool is(const double& left, const float& right){
		return is(left, right, "");
	}

	inline bool is(const double& left, const double& right){
		return is(left, right, "");
	}

	inline bool isnt(const float& left, const float& right){
		return isnt(left, right, "");
	}

	inline bool isnt(const float& left, const double& right){
		return isnt(left, right, "");
	}

	inline bool isnt(const double& left, const float& right){
		return isnt(left, right, "");
	}

	inline bool isnt(const double& left, const double& right){
		return isnt(left, right, "");
	}

	extern std::string TODO;

	class todo_guard {
		const std::string value;
		public:
		todo_guard() throw();
		~todo_guard() throw();
	};
}

#ifdef WANT_TEST_EXTRAS

namespace TAP {
	namespace details {
		struct Skip_exception {
			const std::string reason;
			Skip_exception(const std::string& _reason) throw() : reason(_reason) {
			}
		};
		struct Todo_exception {
			const std::string reason;
			Todo_exception(const std::string& _reason) throw() : reason(_reason) {
			}
		};

		void start_block(unsigned) throw();
		unsigned stop_block() throw(fatal_exception);

	}

	void skip(const std::string& reason) throw(details::Skip_exception);
	void skip_todo(const std::string& reason) throw(details::Todo_exception);
}

#define TRY(action, name) do {\
		try {\
			action;\
			TAP::pass(name);\
		}\
		catch (const std::exception& e) {\
			TAP::fail(name);\
			note("Caught exception: ", e.what());\
		}\
		catch (...) {\
			TAP::fail(name);\
		}\
	} while (0)

#define FAIL(action, name) do {\
		try {\
			action;\
			TAP::fail(name);\
		}\
		catch (...) {\
			TAP::pass(name);\
		}\
	} while (0)

#define TEST_START(num) {\
		const char* _current_message = NULL;\
		TAP::plan(num);\
		try {

#define TEST_END \
			if (TAP::encountered() < TAP::planned()) {\
				TAP::note("Looks like you planned ", TAP::planned(), " tests but only ran ", TAP::encountered());\
			}\
			else if(TAP::encountered() > TAP::planned()) {\
				TAP::note("Looks like you planned ", TAP::planned(), " tests but ran ", TAP::encountered() - TAP::planned(), " extra");\
			}\
		}\
		catch(TAP::details::Skip_exception& skipper) {\
			TAP::skip(TAP::planned() - TAP::encountered(), skipper.reason);\
		}\
		catch(TAP::details::Todo_exception& todoer) {\
			/*TODO*/\
		}\
		catch(const TAP::fatal_exception& e) {\
			if(_current_message) TAP::fail(_current_message);\
			note("A fatal error occured:,", e.what()," aborting");\
		}\
		catch(const std::exception& e) {\
			if(_current_message) TAP::fail(_current_message);\
			note("Got unknown error: ", e.what());\
		}\
		catch (...) {\
			if(_current_message) TAP::fail(_current_message);\
		}\
		return TAP::exit_status();\
	}

#define BLOCK_START(planned) \
	try {\
		todo_guard foo##planned;\
		TAP::details::start_block(planned);


#define BLOCK_END \
		if (TAP::encountered() != TAP::details::stop_block()) {\
			note("There seems to be a wrong number of tests!");\
		}\
	}\
	catch(TAP::details::Skip_exception& skipper) {\
		TAP::skip(TAP::details::stop_block() - TAP::encountered(), skipper.reason);\
	}\
	catch(TAP::details::Todo_exception& todoer) {\
		note("Can't handle todo properly yet");\
		/*TODO*/\
	}\
	catch(const std::exception& e) {\
		TAP::fail(_current_message);\
		note("Got error: ", e.what());\
	}\
	catch (...) {\
		TAP::fail(_current_message);\
		note("Died with some mysterious error");\
	}

/* This small macro is a main reason for this ugly exercise. I can't introduce a new scope because
 * code subsequent to the declaration should be visible to the rest of the code. At the same time, it
 * must be exception safe. They are quite severe constraints :-(.
 */
#define TRY_DECL(action, new_message) \
	_current_message = new_message;\
	action;\
	TAP::pass(_current_message);\
	_current_message = NULL

#endif /* WANT_TEST_EXTRAS */


#endif /* LIB_TAPPP_TAPPP_H */

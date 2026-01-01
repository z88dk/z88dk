//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "catch_amalgamated.hpp"
#include <iostream>
#include <sstream>

// Helper to capture std::cerr output
class CerrRedirect {
    std::ostringstream ss;
    std::streambuf* old;
public:
    CerrRedirect() : old(std::cerr.rdbuf(ss.rdbuf())) {}
    ~CerrRedirect() {
        std::cerr.rdbuf(old);
    }
    std::string str() const {
        return ss.str();
    }
};

TEST_CASE("Errors counts errors", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.error(ErrorCode::FileNotFound);
    er.error(ErrorCode::InvalidSyntax, "foo");
    REQUIRE(er.error_count() == 2);
    REQUIRE(er.has_errors());
    REQUIRE_FALSE(er.has_warnings());
}

TEST_CASE("Errors does not count warnings", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.warning(ErrorCode::FileNotFound);
    er.warning(ErrorCode::InvalidSyntax, "foo");
    REQUIRE(er.error_count() == 0);
    REQUIRE_FALSE(er.has_errors());
    REQUIRE(er.has_warnings());
}

TEST_CASE("Errors prints error", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.error(ErrorCode::FileNotFound, "test.asm");
    std::string output = redirect.str();
    REQUIRE(output.find("error: File not found: test.asm") != std::string::npos);
}

TEST_CASE("Errors prints warning", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.warning(ErrorCode::FileNotFound, "test.asm");
    std::string output = redirect.str();
    REQUIRE(output.find("warning: File not found: test.asm") != std::string::npos);
}

TEST_CASE("Errors prints with Location", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.set_location(Location("foo.asm", 42));
    er.error(ErrorCode::InvalidSyntax, "bad token");
    std::string output = redirect.str();
    REQUIRE(output.find("foo.asm:42: error: Invalid syntax: bad token") !=
            std::string::npos);
    REQUIRE(er.last_error_message().find(
                "foo.asm:42: error: Invalid syntax: bad token") !=
            std::string::npos);
}

TEST_CASE("Errors prints with Location and source file", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.set_location(Location("foo.asm", 42));
    er.set_source_line("LD A, 42");
    er.set_expanded_line("LD A,42");
    er.error(ErrorCode::InvalidSyntax, "bad token");
    REQUIRE(er.last_error_message().find(
                "foo.asm:42: error: Invalid syntax: bad token") !=
            std::string::npos);
    REQUIRE(er.last_error_message().find("   |LD A, 42") !=
            std::string::npos);
    REQUIRE(er.last_error_message().find("   |LD A,42") !=
            std::string::npos);
}

TEST_CASE("Errors::reset resets error count and last error message",
          "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.error(ErrorCode::FileNotFound, "foo.asm");
    REQUIRE(er.error_count() == 1);
    REQUIRE(er.has_errors());
    REQUIRE_FALSE(er.last_error_message().empty());
    er.reset();
    REQUIRE(er.error_count() == 0);
    REQUIRE_FALSE(er.has_errors());
    REQUIRE(er.last_error_message().empty());
}

TEST_CASE("Errors::clear clears location and lines but not error count",
          "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.set_location(Location("bar.asm", 99));
    er.set_source_line("LD HL,0");
    er.set_expanded_line("LD HL,0");
    er.error(ErrorCode::FileNotFound, "bar.asm");
    REQUIRE(er.error_count() == 1);
    er.clear();
    // error_count should remain
    REQUIRE(er.error_count() == 1);
    // location and lines should be cleared
    REQUIRE(er.location().filename().empty());
    REQUIRE(er.location().line_num() == 0);
}

TEST_CASE("Errors::filename and line_num reflect location", "[Errors]") {
    Errors er;
    er.set_location(Location("baz.asm", 123));
    REQUIRE(er.location().filename() == "baz.asm");
    REQUIRE(er.location().line_num() == 123);
}

TEST_CASE("Errors::set_source_line and set_expanded_line store lines",
          "[Errors]") {
    Errors er;
    er.set_source_line("ORG 0");
    er.set_expanded_line("ORG 0");
    // These are private, but their effect is visible in last_error_message
    CerrRedirect redirect;
    er.set_location(Location("foo.asm", 1));
    er.error(ErrorCode::InvalidSyntax, "bad");
    std::string msg = er.last_error_message();
    REQUIRE(msg.find("ORG 0") != std::string::npos);
}

TEST_CASE("Errors::last_error_message returns last error", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    er.error(ErrorCode::FileNotFound, "file.asm");
    std::string msg = er.last_error_message();
    REQUIRE(msg.find("File not found: file.asm") != std::string::npos);
    er.error(ErrorCode::InvalidSyntax, "oops");
    std::string msg2 = er.last_error_message();
    REQUIRE(msg2.find("Invalid syntax: oops") != std::string::npos);
}

TEST_CASE("Errors::has_errors returns false when no errors", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    REQUIRE_FALSE(er.has_errors());
    er.warning(ErrorCode::FileNotFound, "file.asm");
    REQUIRE_FALSE(er.has_errors());
}

TEST_CASE("Errors::error_count returns correct count", "[Errors]") {
    Errors er;
    CerrRedirect redirect;
    REQUIRE(er.error_count() == 0);
    er.error(ErrorCode::FileNotFound);
    REQUIRE(er.error_count() == 1);
    er.error(ErrorCode::InvalidSyntax);
    REQUIRE(er.error_count() == 2);
}

TEST_CASE("Errors shows both source and expanded lines when they differ",
          "[Errors][lines][different]") {
    Errors er;
    CerrRedirect redirect;
    er.set_location(Location("diff.asm", 5));
    er.set_source_line("LD A, 42");
    er.set_expanded_line("LD A,42");
    er.error(ErrorCode::InvalidSyntax, "bad token");
    std::string out = redirect.str();
    // Error header
    REQUIRE(out.find("diff.asm:5: error: Invalid syntax: bad token") !=
            std::string::npos);
    // Source line present
    REQUIRE(out.find("   |LD A, 42") != std::string::npos);
    // Expanded line present (different spacing)
    REQUIRE(out.find("   |LD A,42") != std::string::npos);
}

TEST_CASE("Errors shows only source line when expanded line equals source",
          "[Errors][lines][equal]") {
    Errors er;
    CerrRedirect redirect;
    er.set_location(Location("same.asm", 7));
    er.set_source_line("NOP");
    er.set_expanded_line("NOP"); // identical
    er.error(ErrorCode::InvalidSyntax, "unexpected");
    std::string out = redirect.str();
    // Header
    REQUIRE(out.find("same.asm:7: error: Invalid syntax: unexpected") !=
            std::string::npos);
    // Source line appears
    REQUIRE(out.find("   |NOP") != std::string::npos);
    // Count occurrences of the marker line; should be exactly one
    size_t pos = out.find("   |NOP");
    REQUIRE(pos != std::string::npos);
    REQUIRE(out.find("   |NOP", pos + 1) == std::string::npos);
}

TEST_CASE("Errors: error with explicit location", "[errors][location]") {
    SuppressErrors suppress;

    Location loc("test.asm", 42);
    g_errors.error(loc, ErrorCode::InvalidSyntax, "test error");

    REQUIRE(g_errors.has_errors());
    REQUIRE(g_errors.error_count() == 1);

    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:42:") != std::string::npos);
    REQUIRE(msg.find("error") != std::string::npos);
    REQUIRE(msg.find("test error") != std::string::npos);
}

TEST_CASE("Errors: warning with explicit location", "[errors][location]") {
    SuppressErrors suppress;

    Location loc("source.asm", 100);
    g_errors.warning(loc, ErrorCode::InvalidSyntax, "test warning");

    REQUIRE_FALSE(g_errors.has_errors()); // warnings don't increment error count
    REQUIRE(g_errors.error_count() == 0);

    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("source.asm:100:") != std::string::npos);
    REQUIRE(msg.find("warning") != std::string::npos);
    REQUIRE(msg.find("test warning") != std::string::npos);
}

TEST_CASE("Errors: explicit location doesn't change internal location",
          "[errors][location]") {
    SuppressErrors suppress;

    // Set internal location
    Location internal_loc("internal.asm", 10);
    g_errors.set_location(internal_loc);

    // Report error with different location
    Location error_loc("error.asm", 20);
    g_errors.error(error_loc, ErrorCode::InvalidSyntax, "external error");

    // Internal location should remain unchanged
    REQUIRE(g_errors.location().filename() == "internal.asm");
    REQUIRE(g_errors.location().line_num() == 10);

    // Error message should use the explicit location
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("error.asm:20:") != std::string::npos);
}

TEST_CASE("Errors: explicit location with empty location",
          "[errors][location]") {
    SuppressErrors suppress;

    Location empty_loc;
    g_errors.error(empty_loc, ErrorCode::InvalidSyntax, "no location");

    std::string msg = g_errors.last_error_message();
    // Should not have filename:line prefix
    REQUIRE(msg.find("error:") == 0);
}

TEST_CASE("Errors: multiple errors with explicit locations",
          "[errors][location]") {
    SuppressErrors suppress;

    Location loc1("file1.asm", 10);
    Location loc2("file2.asm", 20);
    Location loc3("file3.asm", 30);

    g_errors.error(loc1, ErrorCode::InvalidSyntax, "error 1");
    g_errors.error(loc2, ErrorCode::InvalidSyntax, "error 2");
    g_errors.warning(loc3, ErrorCode::InvalidSyntax, "warning 3");

    REQUIRE(g_errors.error_count() == 2); // Only errors count

    // Last message should be the warning
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("file3.asm:30:") != std::string::npos);
    REQUIRE(msg.find("warning 3") != std::string::npos);
}

TEST_CASE("Errors: expression error example",
          "[errors][location][expression]") {
    SuppressErrors suppress;

    // Simulate an expression defined at a specific location
    Location expr_loc("math.asm", 55);

    // Later during evaluation, report error using the expression's location
    g_errors.error(expr_loc, ErrorCode::DivisionByZero);

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("math.asm:55:") != std::string::npos);
    REQUIRE(msg.find("Division by zero") != std::string::npos);
}

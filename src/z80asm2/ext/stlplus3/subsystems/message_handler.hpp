#ifndef STLPLUS_MESSAGE_HANDLER
#define STLPLUS_MESSAGE_HANDLER
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   A general-purpose message handler using a message file as the source of all text

////////////////////////////////////////////////////////////////////////////////
#include "subsystems_fixes.hpp"
#include "smart_ptr.hpp"
#include <iostream>
#include <string>
#include <vector>
#include <stdexcept>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // Internals

  class message_handler_base;
  class message_handler_base_body;

  class message_handler;
  class message_handler_body;

  class message_context_body;

  ////////////////////////////////////////////////////////////////////////////////
  // an object representing a file position
  // used for example when reporting errors when parsing a text file

  class message_position
  {
  public:
    message_position(void);
    message_position(const std::string& filename, unsigned line, unsigned column);
    ~message_position(void);

    // access the elements of the position
    const std::string& filename(void) const;
    // line number in the range 1..n
    // so line 0 means uninitialised
    unsigned line(void) const;
    // column number in the range 0..m-1
    unsigned column(void) const;

    // add a column offset to a position
    message_position operator + (unsigned) const;
    message_position& operator += (unsigned);

    // tests for valid position
    bool empty(void) const;
    bool valid(void) const;

    // vector of two strings
    // - the first reproducing the source line
    // - the second an arrow pointing to the correct column
    // the vector will be empty if the position can't be found
    std::vector<std::string> show(void) const;

  private:
    std::string m_filename;
    unsigned m_line;
    unsigned m_column;
  };

  std::string to_string(const message_position& where);

  //////////////////////////////////////////////////////////////////////////////
  // an object representing an message context
  // used to control the context stack
  // on initialisation, the message_context stores the state of the context stack
  // on destruction it restores the state by popping any context that has been pushed since creation

  class message_context
  {
  public:
    message_context(message_handler_base& handler);

    void set(message_handler_base& handler);
    void pop(void);

  private:
    friend class message_context_body;
    friend class message_handler_base;
    smart_ptr_nocopy<message_context_body> m_body;
  };

  ////////////////////////////////////////////////////////////////////////////////
  // exception classes which can be thrown by the message handler

  // read_error is thrown if the message file read fails
  class message_handler_read_error : public std::runtime_error
  {
  public:
    message_handler_read_error(const message_position& position, const std::string& reason);
    ~message_handler_read_error(void) throw();

    const message_position& where(void) const;

  private:
    message_position m_position;
  };

  // format_error is thrown if a formatting error occurs trying to create the text for the message

  class message_handler_format_error : public std::runtime_error
  {
  public:
    message_handler_format_error(const std::string& format, unsigned offset);
    message_handler_format_error(const message_position& pos, const std::string& format, unsigned offset);
    ~message_handler_format_error(void) throw();

    const message_position& where(void) const;
    const std::string& format(void) const;
    unsigned offset(void) const;

  private:
    message_position m_position;
    std::string m_format;
    unsigned m_offset;
  };

  // id_error is thrown if an error id is requested that could not be found in the message file

  class message_handler_id_error : public std::runtime_error
  {
  public:
    message_handler_id_error(const std::string& id);
    ~message_handler_id_error(void) throw();

    const std::string& id(void) const;

  private:
    std::string m_id;
  };

  // limit_error is thrown when the number of errors reaches the error limit

  class message_handler_limit_error : public std::runtime_error
  {
  public:
    message_handler_limit_error(unsigned limit);
    ~message_handler_limit_error(void) throw();

    unsigned limit(void) const;

  private:
    unsigned m_limit;   // the limit that was exceeded
  };

  // fatal_error is thrown when a fatal error is reported

  class message_handler_fatal_error : public std::runtime_error
  {
  public:
    message_handler_fatal_error(const std::string& id);
    ~message_handler_fatal_error(void) throw();

    const std::string& id(void) const;

  private:
    std::string m_id;
  };

  ////////////////////////////////////////////////////////////////////////////////
  // base version returns message objects as vectors of strings
  // - it is then up to the user to decide what to do with them
  // - suitable for use in a GUI for example where the message is displayed in a dialog

  class message_handler_base
  {
  public:
    //////////////////////////////////////////////////////////////////////////////
    // constructor

    // The first form sets the show flag but doesn't load any message files.
    // The second and third forms also read message file(s) by calling
    // add_message_file and therefore can throw exceptions. The first form
    // defers file reading to explicit calls of add_message_file so does not
    // throw any exceptions.

    // show determines whether the source file line containing the source of a problem should also be shown

    message_handler_base(bool show = true)
      throw();

    message_handler_base(const std::string& message_file, bool show = true)
      throw(message_handler_read_error);

    message_handler_base(const std::vector<std::string>& message_files, bool show = true)
      throw(message_handler_read_error);

    virtual ~message_handler_base(void)
      throw();

    //////////////////////////////////////////////////////////////////////////////
    // message file handling

    // The message file format contains lines of the form:
    //
    // <id> <spaces> <text>
    //
    // In <id> is a unique mnemonic for the message. It starts with an
    // alphabetic character and may contain alphanumerics and underscores only.
    // The <spaces> can be one or more space or tab characters. The <text> is the
    // remainder of the line and is plain text (not a quoted string). All lines
    // starting with a non-alphabetic character are assumed to be comments and are
    // ignored

    // If the message file is missing the function throws read_error with no line
    // number. If formatting errors were found in the file,then it throws a
    // read_error with valid line information.

    // Any number of message files can be added and they accumulate

    void add_message_file(const std::string& message_file)
      throw(message_handler_read_error);

    void add_message_files(const std::vector<std::string>& message_files)
      throw(message_handler_read_error);

    void add_message(const std::string& id, const std::string& text)
      throw();

    bool message_present(const std::string& id) const
      throw();

    //////////////////////////////////////////////////////////////////////////////
    // format control

    // The status formats - that is, information/warning/error/fatal/context/supplement
    // formats take a single argument which is the formatted message
    // For example: "warning: @0"
    //
    // Messages may be printed as either simple or positional
    //   simple:     just a text message, such as a progress report
    //   positional: a message relating to a source file line
    // The formatted message text is generated directly for simple messages
    // However, for positional messages, this text is further substituted
    // into a positional format string.
    // The positional format string takes up to 4 arguments:
    //   @0: simple message text
    //   @1: filename
    //   @2: line number
    //   @3: column number
    // You can miss out a part of this (e.g. the column number)
    // by simply not including the argument number in the format string
    // For example: "file: @1, line: @2: @0"
    //
    // The default formats are:
    //   information: "@0"
    //   warning:     "warning: @0"
    //   error:       "error: @0"
    //   fatal:       "FATAL: @0"
    //   context:     "context: @0"
    //   supplement:  "supplement: @0"
    //
    //   positional:  "\"@1\" (@2,@3) : @0"

    void set_information_format(const std::string& format)
      throw();

    void set_warning_format(const std::string& format)
      throw();

    void set_error_format(const std::string& format)
      throw();

    void set_fatal_format(const std::string& format)
      throw();

    void set_context_format(const std::string& format)
      throw();

    void set_supplement_format(const std::string& format)
      throw();

    void set_position_format(const std::string& format)
      throw();

    //////////////////////////////////////////////////////////////////////////////
    // source file position display control
    // show_position indicates that the source file line containing the error
    //   should be shown with the message on subsequent lines
    // hide_position indicates that the source file line should not be shown

    void show_position(void)
      throw();

    void hide_position(void)
      throw();

    //////////////////////////////////////////////////////////////////////////////
    // Message formatting functions
    // These functions return a vector of strings containing the completed message

    // There are 6 classes of message: information, context, supplement, warning, error, fatal
    // The 4 main classes are:
    //   - information: progress messages, status messages etc.
    //   - warning: a problem has been found but there is a sensible way of proceeding
    //   - error: a problem has been found and the operation will fail
    //            processing may continue but only to find further errors
    //   - fatal: an internal (programming) error has been found and the operation is stopping NOW
    // The remaining two always follow one of the above
    //   - context: give stack-like information of the error context 
    //              e.g. if processing include files, the sequence of includes forms a stack
    //   - supplement: give extra information of the error context
    //              e.g. give the set of possible solutions to the problem

    // There are 2 kinds of message: simple, positional
    //   - simple: just a text message
    //   - positional: a message relating to a source file and a specific position in that file
    // This gives 8 variants. 
    // Note: a positional message with an empty position is treated as a simple message

    // Messages can have arguments.
    // All arguments are strings.
    // For each variant there are 5 functions relating to different numbers of arguments.
    //   - general form: takes any number of arguments as a vector of strings
    //   - 0 arguments: takes no arguments
    //   - 1 argument: allows a single argument
    //   - 2 arguments: allows two arguments
    //   - 3 arguments: allows three arguments
    // For more than 3 arguments, use the general form

    // information messages

    // simple messages
    std::vector<std::string> information_message(const std::string& id,
                                                 const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> information_message(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> information_message(const std::string& id,
                                                 const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> information_message(const std::string& id,
                                                 const std::string& arg1,
                                                 const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> information_message(const std::string& id,
                                                 const std::string& arg1,
                                                 const std::string& arg2,
                                                 const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // positional messages
    std::vector<std::string> information_message(const message_position&,
                                                 const std::string& id,
                                                 const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> information_message(const message_position&,
                                                 const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> information_message(const message_position&,
                                                 const std::string& id,
                                                 const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> information_message(const message_position&,
                                                 const std::string& id,
                                                 const std::string& arg1,
                                                 const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> information_message(const message_position&,
                                                 const std::string& id,
                                                 const std::string& arg1,
                                                 const std::string& arg2,
                                                 const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // warning messages

    // simple messages
    std::vector<std::string> warning_message(const std::string& id,
                                             const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> warning_message(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> warning_message(const std::string& id,
                                             const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> warning_message(const std::string& id,
                                             const std::string& arg1,
                                             const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> warning_message(const std::string& id,
                                             const std::string& arg1,
                                             const std::string& arg2,
                                             const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // positional messages
    std::vector<std::string> warning_message(const message_position&,
                                             const std::string& id,
                                             const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> warning_message(const message_position&,
                                             const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> warning_message(const message_position&,
                                             const std::string& id,
                                             const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> warning_message(const message_position&,
                                             const std::string& id,
                                             const std::string& arg1,
                                             const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> warning_message(const message_position&,
                                             const std::string& id,
                                             const std::string& arg1,
                                             const std::string& arg2,
                                             const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // error messages

    // simple messages
    std::vector<std::string> error_message(const std::string& id,
                                           const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> error_message(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> error_message(const std::string& id,
                                           const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> error_message(const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> error_message(const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2,
                                           const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // positional messages
    std::vector<std::string> error_message(const message_position&,
                                           const std::string& id,
                                           const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> error_message(const message_position&,
                                           const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> error_message(const message_position&,
                                           const std::string& id,
                                           const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> error_message(const message_position&,
                                           const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> error_message(const message_position&,
                                           const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2,
                                           const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // fatal messages
    // Note that these do not throw the fatal_error exception because that would prevent the message being reported
    // the caller should throw the exception after reporting the message

    // simple messages
    std::vector<std::string> fatal_message(const std::string& id,
                                           const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> fatal_message(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> fatal_message(const std::string& id,
                                           const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> fatal_message(const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> fatal_message(const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2,
                                           const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // positional messages
    std::vector<std::string> fatal_message(const message_position&,
                                           const std::string& id,
                                           const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> fatal_message(const message_position&,
                                           const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> fatal_message(const message_position&,
                                           const std::string& id,
                                           const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> fatal_message(const message_position&,
                                           const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    std::vector<std::string> fatal_message(const message_position&,
                                           const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2,
                                           const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // supplement messages - these must be pushed *before* the message that they apply to

    // simple messages
    void push_supplement(const std::string& id,
                         const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    void push_supplement(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    void push_supplement(const std::string& id,
                         const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    void push_supplement(const std::string& id,
                         const std::string& arg1,
                         const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    void push_supplement(const std::string& id,
                         const std::string& arg1,
                         const std::string& arg2,
                         const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // positional messages
    void push_supplement(const message_position&,
                         const std::string& id,
                         const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    void push_supplement(const message_position&,
                         const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    void push_supplement(const message_position&,
                         const std::string& id,
                         const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    void push_supplement(const message_position&,
                         const std::string& id,
                         const std::string& arg1,
                         const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    void push_supplement(const message_position&,
                         const std::string& id,
                         const std::string& arg1,
                         const std::string& arg2,
                         const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    //////////////////////////////////////////////////////////////////////////////
    // context stack - allows supplementary messages to be printed after each message showing where it came from
    // for example, an message whilst inlining a function could be followed by a "function called from..." message

    // simple context messages
    void push_context(const std::string& id,
                      const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    void push_context(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    void push_context(const std::string& id,
                      const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    void push_context(const std::string& id,
                      const std::string& arg1,
                      const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    void push_context(const std::string& id,
                      const std::string& arg1,
                      const std::string& arg2,
                      const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // positional context messages
    void push_context(const message_position&,
                      const std::string& id,
                      const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    void push_context(const message_position&,
                      const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    void push_context(const message_position&,
                      const std::string& id,
                      const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    void push_context(const message_position&,
                      const std::string& id,
                      const std::string& arg1,
                      const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    void push_context(const message_position&,
                      const std::string& id,
                      const std::string& arg1,
                      const std::string& arg2,
                      const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    unsigned context_depth(void) const
      throw();

    // remove the last level of context if there is one
    void pop_context(void)
      throw();
    // remove context messages to the specified depth
    void pop_context(unsigned)
      throw();

    // push the context and save it in the message_context handle. When the
    // message_context handle goes out of scope, the context is popped
    // automatically

    // simple context messages
    message_context auto_push_context(const std::string& id,
                                      const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    message_context auto_push_context(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    message_context auto_push_context(const std::string& id,
                                      const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    message_context auto_push_context(const std::string& id,
                                      const std::string& arg1,
                                      const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    message_context auto_push_context(const std::string& id,
                                      const std::string& arg1,
                                      const std::string& arg2,
                                      const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // positional context messages
    message_context auto_push_context(const message_position&,
                                      const std::string& id,
                                      const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    message_context auto_push_context(const message_position&,
                                      const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    message_context auto_push_context(const message_position&,
                                      const std::string& id,
                                      const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    message_context auto_push_context(const message_position&,
                                      const std::string& id,
                                      const std::string& arg1,
                                      const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    message_context auto_push_context(const message_position&,
                                      const std::string& id,
                                      const std::string& arg1,
                                      const std::string& arg2,
                                      const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

  private:
    friend class message_handler_base_body;
    smart_ptr_nocopy<message_handler_base_body> m_base_body;
  };

  ////////////////////////////////////////////////////////////////////////////////
  // iostream-based derivative uses the above base class to generate messages then uses iostream to print them
  // Note: since this is a public derivative, all message_handler_base operations are also available

  class message_handler : public message_handler_base
  {
  public:
    //////////////////////////////////////////////////////////////////////////////
    // constructor

    // The device is the output on which to print the error. For command-line tools
    // it will be either std::cout (standard output) or std::cerr (standard error) from
    // <iostream>.

    // The second and third form also reads a message file by calling
    // add_message_file and therefore can throw exceptions. The first form
    // defers file reading to explicit calls of add_message_file so does not
    // throw any exceptions.

    // limit sets the error limit - zero disables this feature
    // show determines whether the source file line containing the error should also be shown

    message_handler(std::ostream& device,unsigned limit = 0,bool show = true) 
      throw();

    message_handler(std::ostream& device,
                    const std::string& message_file,unsigned limit = 0,bool show = true) 
      throw(message_handler_read_error);

    message_handler(std::ostream& device,
                    const std::vector<std::string>& message_files,unsigned limit = 0,bool show = true) 
      throw(message_handler_read_error);

    ~message_handler(void)
      throw();

    //////////////////////////////////////////////////////////////////////////////
    // error count and error limits

    void set_error_limit(unsigned error_limit)
      throw();

    unsigned error_limit(void) const
      throw();

    void reset_error_count(void)
      throw();

    unsigned error_count(void) const
      throw();

    //////////////////////////////////////////////////////////////////////////////
    // access the output device for whatever reason (for example, to ensure that
    // text output goes wherever the messages go)

    std::ostream& device(void);

    //////////////////////////////////////////////////////////////////////////////
    // Message reporting functions
    // These are based on the error formatting functions in the baseclass

    // information messages

    // simple messages
    bool information(const std::string& id,
                     const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    bool information(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    bool information(const std::string& id,
                     const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    bool information(const std::string& id,
                     const std::string& arg1,
                     const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    bool information(const std::string& id,
                     const std::string& arg1,
                     const std::string& arg2,
                     const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // positional messages
    bool information(const message_position&,
                     const std::string& id,
                     const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    bool information(const message_position&,
                     const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    bool information(const message_position&,
                     const std::string& id,
                     const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    bool information(const message_position&,
                     const std::string& id,
                     const std::string& arg1,
                     const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    bool information(const message_position&,
                     const std::string& id,
                     const std::string& arg1,
                     const std::string& arg2,
                     const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // warning messages

    // simple messages
    bool warning(const std::string& id,
                 const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    bool warning(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    bool warning(const std::string& id,
                 const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    bool warning(const std::string& id,
                 const std::string& arg1,
                 const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    bool warning(const std::string& id,
                 const std::string& arg1,
                 const std::string& arg2,
                 const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // positional messages
    bool warning(const message_position&,
                 const std::string& id,
                 const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error);

    bool warning(const message_position&,
                 const std::string& id)
      throw(message_handler_id_error,message_handler_format_error);

    bool warning(const message_position&,
                 const std::string& id,
                 const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error);

    bool warning(const message_position&,
                 const std::string& id,
                 const std::string& arg1,
                 const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error);

    bool warning(const message_position&,
                 const std::string& id,
                 const std::string& arg1,
                 const std::string& arg2,
                 const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error);

    // error messages

    // simple messages
    bool error(const std::string& id,
               const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error);

    bool error(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error);

    bool error(const std::string& id,
               const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error);

    bool error(const std::string& id,
               const std::string& arg1,
               const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error);

    bool error(const std::string& id,
               const std::string& arg1,
               const std::string& arg2,
               const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error);

    // positional messages
    bool error(const message_position&,
               const std::string& id,
               const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error);

    bool error(const message_position&,
               const std::string& id)
      throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error);

    bool error(const message_position&,
               const std::string& id,
               const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error);

    bool error(const message_position&,
               const std::string& id,
               const std::string& arg1,
               const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error);

    bool error(const message_position&,
               const std::string& id,
               const std::string& arg1,
               const std::string& arg2,
               const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error);

    // fatal messages
    // These report the error and then always throw the fatal_error exception

    // simple messages
    bool fatal(const std::string& id,
               const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error);

    bool fatal(const std::string& id)
      throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error);

    bool fatal(const std::string& id,
               const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error);

    bool fatal(const std::string& id,
               const std::string& arg1,
               const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error);

    bool fatal(const std::string& id,
               const std::string& arg1,
               const std::string& arg2,
               const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error);

    // positional messages
    bool fatal(const message_position&,
               const std::string& id,
               const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error);

    bool fatal(const message_position&,
               const std::string& id)
      throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error);

    bool fatal(const message_position&,
               const std::string& id,
               const std::string& arg1)
      throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error);

    bool fatal(const message_position&,
               const std::string& id,
               const std::string& arg1,
               const std::string& arg2)
      throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error);

    bool fatal(const message_position&,
               const std::string& id,
               const std::string& arg1,
               const std::string& arg2,
               const std::string& arg3)
      throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error);

    //////////////////////////////////////////////////////////////////////////////
    // plain text output
    // provides a simple way of outputting text from the program to the same device as the messages
    // Each call of plaintext is treated as a line of text and has a newline appended

    bool plaintext (const std::string& text);

  private:
    friend class message_handler_body;
    smart_ptr_nocopy<message_handler_body> m_body;
  };

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#endif

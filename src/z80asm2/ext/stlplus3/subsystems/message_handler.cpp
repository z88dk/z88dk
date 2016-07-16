////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "message_handler.hpp"
#include "dprintf.hpp"
#include <fstream>
#include <map>
#include <list>
#include <ctype.h>
////////////////////////////////////////////////////////////////////////////////

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // Utilities

  static std::ostream& operator<< (std::ostream& device, const std::vector<std::string>& data)
  {
    for (unsigned i = 0; i < data.size(); i++)
      device << data[i] << std::endl;
    device.flush();
    return device;
  }

  ////////////////////////////////////////////////////////////////////////////////

  static const char* information_id = "INFORMATION";
  static const char* context_id = "CONTEXT";
  static const char* supplement_id = "SUPPLEMENT";
  static const char* warning_id = "WARNING";
  static const char* error_id = "ERROR";
  static const char* fatal_id = "FATAL";
  static const char* position_id = "POSITION";

  static const char* default_information_format = "@0";
  static const char* default_context_format = "context: @0";
  static const char* default_supplement_format = "supplement: @0";
  static const char* default_warning_format = "warning: @0";
  static const char* default_error_format = "error: @0";
  static const char* default_fatal_format = "FATAL: @0";
  static const char* default_position_format = "\"@1\" (@2,@3) : @0";

  ////////////////////////////////////////////////////////////////////////////////
  // position class

  message_position::message_position(void) :
    m_filename(std::string()), m_line(0), m_column(0) 
  {
  }

  message_position::message_position(const std::string& filename, unsigned line, unsigned column) :
    m_filename(filename), m_line(line), m_column(column)
  {
  }

  message_position::~message_position(void)
  {
  }

  const std::string& message_position::filename(void) const
  {
    return m_filename;
  }

  unsigned message_position::line(void) const
  {
    return m_line;
  }

  unsigned message_position::column(void) const
  {
    return m_column;
  }

  message_position message_position::operator + (unsigned offset) const
  {
    message_position result(*this);
    result += offset;
    return result;
  }

  message_position& message_position::operator += (unsigned offset)
  {
    m_column += offset;
    return *this;
  }

  bool message_position::empty(void) const
  {
    return m_filename.empty();
  }

  bool message_position::valid(void) const
  {
    return !empty();
  }

  std::vector<std::string> message_position::show(void) const
  {
    std::vector<std::string> result;
    if (valid())
    {
      // skip row-1 lines of the file and print out the resultant line
      std::ifstream source(filename().c_str());
      std::string current_line;
      for (unsigned i = 0; i < line(); i++)
      {
        if (!source.good())
          return result;
        std::getline(source,current_line);
      }
      result.push_back(current_line);
      // now put an up-arrow at the appropriate column
      // preserve any tabs in the original line
      result.push_back(std::string());
      for (unsigned j = 0; j < column(); j++)
      {
        if (j < current_line.size() && current_line[j] == '\t')
          result.back() += '\t';
        else
          result.back() += ' ';
      }
      result.back() += '^';
    }
    return result;
  }

  std::string to_string(const message_position& where)
  {
    return dformat("{%s:%u:%u}", where.filename().c_str(), where.line(), where.column());
  }

  ////////////////////////////////////////////////////////////////////////////////
  // context subclass

  class message_context_body
  {
  private:
    unsigned m_depth;
    message_handler_base* m_base;

  public:
    message_context_body(message_handler_base& handler) :
      m_depth(0), m_base(0)
      {
        set(handler);
      }

    ~message_context_body(void)
      {
        pop();
      }

    void set(message_handler_base& handler)
      {
        m_base = &handler;
        m_depth = m_base->context_depth();
      }

    void pop(void)
      {
        if (m_base)
          m_base->pop_context(m_depth);
      }
  private:
    message_context_body(const message_context_body&);
    message_context_body& operator=(const message_context_body&);
  };

  // exported context class

  message_context::message_context(message_handler_base& handler) : m_body(new message_context_body(handler))
  {
  }

  void message_context::set(message_handler_base& handler)
  {
    m_body->set(handler);
  }

  void message_context::pop(void)
  {
    m_body->pop();
  }

  ////////////////////////////////////////////////////////////////////////////////
  // exceptions

  // read_error

  message_handler_read_error::message_handler_read_error(const message_position& position, const std::string& reason) :
    std::runtime_error(to_string(position) + std::string(": Message handler read error - ") + reason), 
    m_position(position)
  {
  }

  message_handler_read_error::~message_handler_read_error(void) throw()
  {
  }

  const message_position& message_handler_read_error::where(void) const
  {
    return m_position;
  }

  // format error

  message_handler_format_error::message_handler_format_error(const std::string& format, unsigned offset) :
    std::runtime_error(std::string("Message handler formatting error in \"") + format + std::string("\"")),
    m_position("",0,0), m_format(format), m_offset(offset)
  {
  }

  message_handler_format_error::message_handler_format_error(const message_position& pos, const std::string& format, unsigned offset) : 
    std::runtime_error(to_string(pos) + std::string(": Message handler formatting error in \"") + format + std::string("\"")), 
    m_position(pos), m_format(format), m_offset(offset)
  {
  }

  message_handler_format_error::~message_handler_format_error(void) throw()
  {
  }

  const message_position& message_handler_format_error::where(void) const
  {
    return m_position;
  }

  const std::string& message_handler_format_error::format(void) const
  {
    return m_format;
  }

  unsigned message_handler_format_error::offset(void) const
  {
    return m_offset;
  }

  // id_error

  message_handler_id_error::message_handler_id_error(const std::string& id) :
    std::runtime_error(std::string("Message handler message ID not found: ") + id), m_id(id)
  {
  }

  message_handler_id_error::~message_handler_id_error(void) throw()
  {
  }

  const std::string& message_handler_id_error::id(void) const
  {
    return m_id;
  }

  // limit_error

  message_handler_limit_error::message_handler_limit_error(unsigned limit) : 
    std::runtime_error(std::string("Message handler limit error: ") + dformat("%u",limit) + std::string(" reached")),
    m_limit(limit)
  {
  }

  message_handler_limit_error::~message_handler_limit_error(void) throw()
  {
  }

  unsigned message_handler_limit_error::limit(void) const
  {
    return m_limit;
  }

  // fatal_error

  message_handler_fatal_error::message_handler_fatal_error(const std::string& id) : 
    std::runtime_error(std::string("Message Handler Fatal error: ") + id),
    m_id(id)
  {
  }

  message_handler_fatal_error::~message_handler_fatal_error(void) throw()
  {
  }

  const std::string& message_handler_fatal_error::id(void) const
  {
    return m_id;
  }

  ////////////////////////////////////////////////////////////////////////////////

  class message
  {
  private:
    unsigned m_index;    // index into message files
    unsigned m_line;     // line
    unsigned m_column;   // column
    std::string m_text;  // text

  public:
    message(unsigned index = (unsigned)-1,
            unsigned line = 0,
            unsigned column = 0,
            const std::string& text = "") :
      m_index(index),m_line(line),m_column(column),m_text(text)
      {
      }
    message(const std::string& text) :
      m_index((unsigned)-1),m_line(0),m_column(0),m_text(text)
      {
      }

    ~message(void)
      {
      }

    unsigned index(void) const
      {
        return m_index;
      }

    unsigned line(void) const
      {
        return m_line;
      }

    unsigned column(void) const
      {
        return m_column;
      }

    const std::string& text(void) const
      {
        return m_text;
      }
  };

  ////////////////////////////////////////////////////////////////////////////////

  class pending_message
  {
  private:
    message_position m_position;
    std::string m_id;
    std::vector<std::string> m_args;
  public:
    pending_message(const message_position& position, const std::string& id, const std::vector<std::string>& args) :
      m_position(position), m_id(id), m_args(args) {}
    pending_message(const std::string& id, const std::vector<std::string>& args) :
      m_position(message_position()), m_id(id), m_args(args) {}
    ~pending_message(void) {}

    const message_position& position(void) const {return m_position;}
    const std::string& id(void) const {return m_id;}
    const std::vector<std::string>& args(void) const {return m_args;}
  };

  ////////////////////////////////////////////////////////////////////////////////

  class message_handler_base_body
  {
  public:
    std::vector<std::string> m_files;          // message files in the order they were added
    std::map<std::string,message> m_messages;  // messages stored as id:message pairs
    bool m_show;                               // show source
    std::list<pending_message> m_context;      // context message stack
    std::list<pending_message> m_supplement;   // supplementary message stack

  public:
    message_handler_base_body(void) :
      m_show(false)
      {
        // preload with default formats
        add_message(information_id,default_information_format);
        add_message(warning_id,default_warning_format);
        add_message(error_id,default_error_format);
        add_message(fatal_id,default_fatal_format);
        add_message(position_id,default_position_format);
        add_message(context_id,default_context_format);
        add_message(supplement_id,default_supplement_format);
      }

    ~message_handler_base_body(void)
      {
      }

    void set_show(bool show)
      {
        m_show = show;
      }

    void add_message_file(const std::string& file)
      throw(message_handler_read_error)
      {
        m_files.push_back(file);
        std::ifstream input(file.c_str());
        if (!input.good()) 
          throw message_handler_read_error(message_position(file,0,0), std::string("file not found: ") + file);
        std::string line;
        unsigned l = 0;
        while(input.good())
        {
          std::getline(input,line);
          l++;
          if (line.size() > 0 && isalpha(line[0]))
          {
            // Get the id field which starts with an alphabetic and contains alphanumerics and underscore
            std::string id;
            unsigned i = 0;
            for (; i < line.size(); i++)
            {
              if (isalnum(line[i]) || line[i] == '_')
                id += line[i];
              else
                break;
            }
            // check this ID is unique within the files - however it is legal to override a hard-coded message
            std::map<std::string,message>::iterator found = m_messages.find(id);
            if (found != m_messages.end() && found->second.index() != (unsigned)-1)
              throw message_handler_read_error(message_position(file,l,i), std::string("repeated ID ") + id);
            // skip whitespace
            for (; i < line.size(); i++)
            {
              if (!isspace(line[i]))
                break;
            }
            // now get the text part and add the message to the message map
            std::string text = line.substr(i, line.size()-i);
            m_messages[id] = message(static_cast<unsigned>(m_files.size())-1, l, i, text);
          }
        }
      }

    void add_message(const std::string& id, const std::string& text)
      throw()
      {
        m_messages[id] = message((unsigned)-1, 0, 0, text);
      }

    bool message_present(const std::string& id) const
      throw()
      {
        return m_messages.find(id) != m_messages.end();
      }

    void push_supplement(const message_position& position,
                         const std::string& message_id,
                         const std::vector<std::string>& args)
      {
        m_supplement.push_back(pending_message(position,message_id,args));
      }

    void push_context(const message_position& position,
                      const std::string& message_id,
                      const std::vector<std::string>& args)
      {
        m_context.push_back(pending_message(position,message_id,args));
      }

    void pop_context(unsigned depth)
      {
        while (depth < m_context.size())
          m_context.pop_back();
      }

    unsigned context_depth(void) const
      {
        return static_cast<unsigned>(m_context.size());
      }

    std::vector<std::string> format_report(const message_position& position,
                                           const std::string& message_id,
                                           const std::string& status_id,
                                           const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error)
      {
        // gathers everything together into a full multi-line report
        std::vector<std::string> result;
        // the first part of the report is the status message (info/warning/error/fatal)
        result.push_back(format_id(position, message_id, status_id, args));
        // now append any supplemental messages that have been stacked
        // these are printed in FIFO order i.e. the order that they were added to the handler
        for (std::list<pending_message>::iterator j = m_supplement.begin(); j != m_supplement.end(); j++)
          result.push_back(format_id(j->position(),j->id(),supplement_id,j->args()));
        // now discard any supplementary messages because they only persist until they are printed once
        m_supplement.clear();
        // now append any context messages that have been stacked
        // these are printed in LIFO order i.e. closest context first
        for (std::list<pending_message>::reverse_iterator i = m_context.rbegin(); i != m_context.rend(); i++)
          result.push_back(format_id(i->position(),i->id(),context_id,i->args()));
        return result;
      }

    std::string format_id(const message_position& position,
                          const std::string& message_id,
                          const std::string& status_id,
                          const std::vector<std::string>& args)
      throw(message_handler_id_error,message_handler_format_error)
      {
        // This function creates a fully-formatted single-line message from a
        // combination of the position format and the status format plus the message
        // ID and its arguments. There are up to three levels of substitution
        // required to do this.

        // get the status format from the status_id
        std::map<std::string,message>::iterator status_found = m_messages.find(status_id);
        if (status_found == m_messages.end()) throw message_handler_id_error(status_id);

        // similarly get the message format
        std::map<std::string,message>::iterator message_found = m_messages.find(message_id);
        if (message_found == m_messages.end()) throw message_handler_id_error(message_id);

        // format the message contents
        std::string message_text = format_message(message_found->second, args);

        // now format the message in the status string (informational, warning etc).
        std::vector<std::string> status_args;
        status_args.push_back(message_text);
        std::string result = format_message(status_found->second, status_args);

        // finally, if the message is positional, format the status message in the positional string
        if (position.valid())
        {
          // get the position format from the message set
          std::map<std::string,message>::iterator position_found = m_messages.find(position_id);
          if (position_found == m_messages.end()) throw message_handler_id_error(position_id);

          // now format the message
          std::vector<std::string> position_args;
          position_args.push_back(result);
          position_args.push_back(position.filename());
          position_args.push_back(dformat("%u",position.line()));
          position_args.push_back(dformat("%u",position.column()));
          result = format_message(position_found->second, position_args);
          // add the source file text and position if that option is on

          if (m_show)
          {
            std::vector<std::string> show = position.show();
            for (unsigned i = 0; i < show.size(); i++)
            {
              result += std::string("\n");
              result += show[i];
            }
          }
        }
        return result;
      }

    std::string format_message(const message& mess,
                               const std::vector<std::string>& args) 
      throw(message_handler_format_error)
      {
        // this function creates a formatted string from the stored message text and
        // the arguments. Most of the work is done in format_string. However, if a
        // formatting error is found, this function uses extra information stored in
        // the message data structure to improve the reporting of the error
        try
        {
          // This is the basic string formatter which performs parameter substitution
          // into a message. Parameter placeholders are in the form @0, @1 etc, where
          // the number is the index of the argument in the args vector. At present,
          // no field codes are supported as in printf formats Algorithm: scan the
          // input string and transfer it into the result. When an @nnn appears,
          // substitute the relevant argument from the args vector. Throw an exception
          // if its out of range. Also convert C-style escaped characters of the form
          // \n.
          std::string format = mess.text();
          std::string result;
          for (unsigned i = 0; i < format.size(); )
          {
            if (format[i] == '@')
            {
              // an argument substitution has been found - now find the argument number
              if (i+1 == format.size()) throw message_handler_format_error(format, i);
              i++;
              // check for @@ which is an escaped form of '@'
              if (format[i] == '@')
              {
                result += '@';
                i++;
              }
              else
              {
                // there must be at least one digit in the substitution number
                if (!isdigit(format[i])) throw message_handler_format_error(format,i);
                unsigned a = 0;
                for (; i < format.size() && isdigit(format[i]); i++)
                {
                  a *= 10;
                  a += (format[i] - '0');
                }
                // check for an argument request out of the range of the set of arguments
                if (a >= args.size()) throw message_handler_format_error(format,i-1);
                result += args[a];
              }
            }
            else if (format[i] == '\\')
            {
              // an escaped character has been found
              if (i+1 == format.size()) throw message_handler_format_error(format, i);
              i++;
              // do the special ones first, then all the others just strip off the \ and leave the following characters
              switch(format[i])
              {
              case '\\':
                result += '\\';
                break;
              case 't':
                result += '\t';
                break;
              case 'n':
                result += '\n';
                break;
              case 'r':
                result += '\r';
                break;
              case 'a':
                result += '\a';
                break;
              default:
                result += format[i];
                break;
              }
              i++;
            }
            else
            {
              // plain text found - just append to the result
              result += format[i++];
            }
          }
          return result;
        }
        catch(message_handler_format_error& exception)
        {
          // if the message came from a message file, improve the error reporting by adding file positional information
          // Also adjust the position from the start of the text (stored in the message field) to the column of the error
          if (mess.index() != (unsigned)-1)
            throw message_handler_format_error(
              message_position(m_files[mess.index()], mess.line(), mess.column()+exception.offset()),
              exception.format(),
              exception.offset());
          else
            throw exception;
        }
      }

  private:
    message_handler_base_body(message_handler_base_body&);
    message_handler_base_body& operator=(message_handler_base_body&);
  };

  ////////////////////////////////////////////////////////////////////////////////

  message_handler_base::message_handler_base(bool show)
    throw() :
    m_base_body(new message_handler_base_body)
  {
    m_base_body->set_show(show);
  }

  message_handler_base::message_handler_base(const std::string& file, bool show)
    throw(message_handler_read_error) :
    m_base_body(new message_handler_base_body)
  {
    m_base_body->set_show(show);
    add_message_file(file);
  }

  message_handler_base::message_handler_base(const std::vector<std::string>& files, bool show)
    throw(message_handler_read_error) :
    m_base_body(new message_handler_base_body)
  {
    m_base_body->set_show(show);
    add_message_files(files);
  }

  message_handler_base::~message_handler_base(void)
    throw()
  {
  }

  ////////////////////////////////////////////////////////////////////////////////

  void message_handler_base::add_message_file(const std::string& file)
    throw(message_handler_read_error)
  {
    m_base_body->add_message_file(file);
  }

  void message_handler_base::add_message_files(const std::vector<std::string>& files)
    throw(message_handler_read_error)
  {
    for (unsigned i = 0; i < files.size(); i++)
      add_message_file(files[i]);
  }

  void message_handler_base::add_message(const std::string& id, const std::string& text)
    throw()
  {
    m_base_body->add_message(id,text);
  }

  bool message_handler_base::message_present(const std::string& id) const
    throw()
  {
    return m_base_body->message_present(id);
  }

  ////////////////////////////////////////////////////////////////////////////////

  void message_handler_base::set_information_format(const std::string& format) throw()
  {
    add_message(information_id, format);
  }

  void message_handler_base::set_warning_format(const std::string& format) throw()
  {
    add_message(warning_id, format);
  }

  void message_handler_base::set_error_format(const std::string& format) throw()
  {
    add_message(error_id, format);
  }

  void message_handler_base::set_fatal_format(const std::string& format) throw()
  {
    add_message(fatal_id, format);
  }

  void message_handler_base::set_position_format(const std::string& format) throw()
  {
    add_message(position_id, format);
  }

  void message_handler_base::set_context_format(const std::string& format) throw()
  {
    add_message(context_id, format);
  }

  void message_handler_base::set_supplement_format(const std::string& format) throw()
  {
    add_message(supplement_id, format);
  }

  ////////////////////////////////////////////////////////////////////////////////

  void message_handler_base::show_position(void)
    throw()
  {
    m_base_body->set_show(true);
  }

  void message_handler_base::hide_position(void)
    throw()
  {
    m_base_body->set_show(false);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // information messages

  std::vector<std::string> message_handler_base::information_message(const std::string& id,
                                                                     const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    return information_message(message_position(), id, args);
  }

  std::vector<std::string> message_handler_base::information_message(const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    return information_message(id, args);
  }

  std::vector<std::string> message_handler_base::information_message(const std::string& id,
                                                                     const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    return information_message(id, args);
  }

  std::vector<std::string> message_handler_base::information_message(const std::string& id,
                                                                     const std::string& arg1,
                                                                     const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    return information_message(id, args);
  }

  std::vector<std::string> message_handler_base::information_message(const std::string& id,
                                                                     const std::string& arg1,
                                                                     const std::string& arg2,
                                                                     const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    return information_message(id, args);
  }

  std::vector<std::string> message_handler_base::information_message(const message_position& position,
                                                                     const std::string& id,
                                                                     const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    return m_base_body->format_report(position, id, information_id, args);
  }

  std::vector<std::string> message_handler_base::information_message(const message_position& position,
                                                                     const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    return information_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::information_message(const message_position& position,
                                                                     const std::string& id,
                                                                     const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    return information_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::information_message(const message_position& position,
                                                                     const std::string& id,
                                                                     const std::string& arg1,
                                                                     const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    return information_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::information_message(const message_position& position,
                                                                     const std::string& id,
                                                                     const std::string& arg1,
                                                                     const std::string& arg2,
                                                                     const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    return information_message(position, id, args);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // warning messages

  std::vector<std::string> message_handler_base::warning_message(const std::string& id,
                                                                 const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    return warning_message(message_position(), id, args);
  }

  std::vector<std::string> message_handler_base::warning_message(const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    return warning_message(id, args);
  }

  std::vector<std::string> message_handler_base::warning_message(const std::string& id,
                                                                 const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    return warning_message(id, args);
  }

  std::vector<std::string> message_handler_base::warning_message(const std::string& id,
                                                                 const std::string& arg1,
                                                                 const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    return warning_message(id, args);
  }

  std::vector<std::string> message_handler_base::warning_message(const std::string& id,
                                                                 const std::string& arg1,
                                                                 const std::string& arg2,
                                                                 const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    return warning_message(id, args);
  }

  std::vector<std::string> message_handler_base::warning_message(const message_position& position,
                                                                 const std::string& id,
                                                                 const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    return m_base_body->format_report(position, id, warning_id, args);
  }

  std::vector<std::string> message_handler_base::warning_message(const message_position& position,
                                                                 const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    return warning_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::warning_message(const message_position& position,
                                                                 const std::string& id,
                                                                 const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    return warning_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::warning_message(const message_position& position,
                                                                 const std::string& id,
                                                                 const std::string& arg1,
                                                                 const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    return warning_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::warning_message(const message_position& position,
                                                                 const std::string& id,
                                                                 const std::string& arg1,
                                                                 const std::string& arg2,
                                                                 const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    return warning_message(position, id, args);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // error messages

  std::vector<std::string> message_handler_base::error_message(const std::string& id,
                                                               const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    return error_message(message_position(), id, args);
  }

  std::vector<std::string> message_handler_base::error_message(const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    return error_message(id, args);
  }

  std::vector<std::string> message_handler_base::error_message(const std::string& id,
                                                               const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    return error_message(id, args);
  }

  std::vector<std::string> message_handler_base::error_message(const std::string& id,
                                                               const std::string& arg1,
                                                               const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    return error_message(id, args);
  }

  std::vector<std::string> message_handler_base::error_message(const std::string& id,
                                                               const std::string& arg1,
                                                               const std::string& arg2,
                                                               const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    return error_message(id, args);
  }

  std::vector<std::string> message_handler_base::error_message(const message_position& position,
                                                               const std::string& id,
                                                               const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    return m_base_body->format_report(position, id, error_id, args);
  }

  std::vector<std::string> message_handler_base::error_message(const message_position& position,
                                                               const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    return error_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::error_message(const message_position& position,
                                                               const std::string& id,
                                                               const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    return error_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::error_message(const message_position& position,
                                                               const std::string& id,
                                                               const std::string& arg1,
                                                               const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    return error_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::error_message(const message_position& position,
                                                               const std::string& id,
                                                               const std::string& arg1,
                                                               const std::string& arg2,
                                                               const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    return error_message(position, id, args);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // fatal messages

  std::vector<std::string> message_handler_base::fatal_message(const std::string& id,
                                                               const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    return fatal_message(message_position(), id, args);
  }

  std::vector<std::string> message_handler_base::fatal_message(const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    return fatal_message(id, args);
  }

  std::vector<std::string> message_handler_base::fatal_message(const std::string& id,
                                                               const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    return fatal_message(id, args);
  }

  std::vector<std::string> message_handler_base::fatal_message(const std::string& id,
                                                               const std::string& arg1,
                                                               const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    return fatal_message(id, args);
  }

  std::vector<std::string> message_handler_base::fatal_message(const std::string& id,
                                                               const std::string& arg1,
                                                               const std::string& arg2,
                                                               const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    return fatal_message(id, args);
  }

  std::vector<std::string> message_handler_base::fatal_message(const message_position& position,
                                                               const std::string& id,
                                                               const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    return m_base_body->format_report(position, id, fatal_id, args);
  }

  std::vector<std::string> message_handler_base::fatal_message(const message_position& position,
                                                               const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    return fatal_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::fatal_message(const message_position& position,
                                                               const std::string& id,
                                                               const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    return fatal_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::fatal_message(const message_position& position,
                                                               const std::string& id,
                                                               const std::string& arg1,
                                                               const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    return fatal_message(position, id, args);
  }

  std::vector<std::string> message_handler_base::fatal_message(const message_position& position,
                                                               const std::string& id,
                                                               const std::string& arg1,
                                                               const std::string& arg2,
                                                               const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    return fatal_message(position, id, args);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // supplemental messages

  void message_handler_base::push_supplement(const std::string& id,
                                             const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    push_supplement(message_position(), id, args);
  }

  void message_handler_base::push_supplement(const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    push_supplement(id, args);
  }

  void message_handler_base::push_supplement(const std::string& id,
                                             const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    push_supplement(id, args);
  }

  void message_handler_base::push_supplement(const std::string& id,
                                             const std::string& arg1,
                                             const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    push_supplement(id, args);
  }

  void message_handler_base::push_supplement(const std::string& id,
                                             const std::string& arg1,
                                             const std::string& arg2,
                                             const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    push_supplement(id, args);
  }

  void message_handler_base::push_supplement(const message_position& position,
                                             const std::string& id,
                                             const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    m_base_body->push_supplement(position, id, args);
  }

  void message_handler_base::push_supplement(const message_position& position,
                                             const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    push_supplement(position, id, args);
  }

  void message_handler_base::push_supplement(const message_position& position,
                                             const std::string& id,
                                             const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    push_supplement(position, id, args);
  }

  void message_handler_base::push_supplement(const message_position& position,
                                             const std::string& id,
                                             const std::string& arg1,
                                             const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    push_supplement(position, id, args);
  }

  void message_handler_base::push_supplement(const message_position& position,
                                             const std::string& id,
                                             const std::string& arg1,
                                             const std::string& arg2,
                                             const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    push_supplement(position, id, args);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // context

  void message_handler_base::push_context (const std::string& id,
                                           const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    push_context(message_position(), id, args);
  }

  void message_handler_base::push_context (const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    push_context(id, args);
  }

  void message_handler_base::push_context (const std::string& id,
                                           const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    push_context(id, args);
  }

  void message_handler_base::push_context (const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    push_context(id, args);
  }

  void message_handler_base::push_context (const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2,
                                           const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    push_context(id, args);
  }

  void message_handler_base::push_context (const message_position& position,
                                           const std::string& id,
                                           const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    m_base_body->push_context(position, id, args);
  }

  void message_handler_base::push_context (const message_position& position,
                                           const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    push_context(position, id, args);
  }

  void message_handler_base::push_context (const message_position& position,
                                           const std::string& id,
                                           const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    push_context(position, id, args);
  }

  void message_handler_base::push_context (const message_position& position,
                                           const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    push_context(position, id, args);
  }

  void message_handler_base::push_context (const message_position& position,
                                           const std::string& id,
                                           const std::string& arg1,
                                           const std::string& arg2,
                                           const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    push_context(position, id, args);
  }

  void message_handler_base::pop_context(void) throw()
  {
    m_base_body->pop_context(m_base_body->context_depth()-1);
  }

  void message_handler_base::pop_context(unsigned depth) throw()
  {
    m_base_body->pop_context(depth);
  }

  unsigned message_handler_base::context_depth(void) const
    throw()
  {
    return m_base_body->context_depth();
  }

  message_context message_handler_base::auto_push_context(const std::string& id, const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    return auto_push_context(message_position(), id, args);
  }

  message_context message_handler_base::auto_push_context(const std::string& id)                                                 
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    return auto_push_context(id, args);
  }

  message_context message_handler_base::auto_push_context(const std::string& id,
                                                          const std::string& arg1)                         
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    return auto_push_context(id, args);
  }

  message_context message_handler_base::auto_push_context (const std::string& id,
                                                           const std::string& arg1,
                                                           const std::string& arg2) 
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    return auto_push_context(id, args);
  }

  message_context message_handler_base::auto_push_context(const std::string& id,
                                                          const std::string& arg1,
                                                          const std::string& arg2,
                                                          const std::string& arg3) 
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    return auto_push_context(id, args);
  }

  message_context message_handler_base::auto_push_context(const message_position& position,
                                                          const std::string& id,
                                                          const std::vector<std::string>& args)            
    throw(message_handler_id_error,message_handler_format_error)
  {
    message_context result(*this);
    m_base_body->push_context(position, id, args);
    return result;
  }

  message_context message_handler_base::auto_push_context(const message_position& position,
                                                          const std::string& id)             
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    return auto_push_context(position, id, args);
  }

  message_context message_handler_base::auto_push_context(const message_position& position,
                                                          const std::string& id,
                                                          const std::string& arg1)                         
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    return auto_push_context(position, id, args);
  }

  message_context message_handler_base::auto_push_context(const message_position& position,
                                                          const std::string& id,
                                                          const std::string& arg1,
                                                          const std::string& arg2) 
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    return auto_push_context(position, id, args);
  }

  message_context message_handler_base::auto_push_context(const message_position& position,
                                                          const std::string& id,
                                                          const std::string& arg1,
                                                          const std::string& arg2,
                                                          const std::string& arg3) 
    throw(message_handler_id_error,message_handler_format_error)
  {
    std::vector<std::string> args;
    args.push_back(arg1);
    args.push_back(arg2);
    args.push_back(arg3);
    return auto_push_context(position, id, args);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // iostream-based derivative uses the above base class to generate messages then uses iostream to print them
  ////////////////////////////////////////////////////////////////////////////////

  class message_handler_body
  {
  private:
    std::ostream* m_device;                        // TextIO output device
    unsigned m_limit;                              // error limit
    unsigned m_errors;                             // error count

  public:
    message_handler_body(std::ostream& device, unsigned limit) :
      m_device(&device), m_limit(limit), m_errors(0)
      {
      }

    ~message_handler_body(void)
      {
        device().flush();
      }

    std::ostream& device(void)
      {
        return *m_device;
      }

    unsigned limit(void) const
      {
        return m_limit;
      }

    void set_limit(unsigned limit)
      {
        m_limit = limit;
      }

    unsigned count(void) const
      {
        return m_errors;
      }

    void set_count(unsigned count)
      {
        m_errors = count;
      }

    void error_increment(void)
      {
        ++m_errors;
      }

    bool limit_reached(void) const
      {
        return m_limit > 0 && m_errors >= m_limit;
      }

  private:
    message_handler_body(const message_handler_body&);
    message_handler_body& operator=(const message_handler_body&);
  };

  ////////////////////////////////////////////////////////////////////////////////

  message_handler::message_handler(std::ostream& device, unsigned limit, bool show)
    throw() :
    message_handler_base(show), m_body(new message_handler_body(device, limit))
  {
  }

  message_handler::message_handler(std::ostream& device,
                                   const std::string& message_file, unsigned limit, bool show) 
    throw(message_handler_read_error) :
    message_handler_base(message_file,show), m_body(new message_handler_body(device, limit))
  {
  }

  message_handler::message_handler(std::ostream& device, const std::vector<std::string>& message_files, unsigned limit, bool show) 
    throw(message_handler_read_error) :
    message_handler_base(message_files,show), m_body(new message_handler_body(device, limit))
  {
  }

  message_handler::~message_handler(void)
    throw()
  {
  }

  ////////////////////////////////////////////////////////////////////////////////
  // error count

  void message_handler::set_error_limit(unsigned error_limit)
    throw()
  {
    m_body->set_limit(error_limit);
  }

  unsigned message_handler::error_limit(void) const
    throw()
  {
    return m_body->limit();
  }

  void message_handler::reset_error_count(void)
    throw()
  {
    m_body->set_count(0);
  }

  unsigned message_handler::error_count(void) const
    throw()
  {
    return m_body->count();
  }

  std::ostream& message_handler::device(void)
  {
    return m_body->device();
  }

  ////////////////////////////////////////////////////////////////////////////////
  // information messages

  bool message_handler::information(const std::string& id,
                                    const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << information_message(id, args);
    return true;
  }

  bool message_handler::information(const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << information_message(id);
    return true;
  }

  bool message_handler::information(const std::string& id,
                                    const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << information_message(id, arg1);
    return true;
  }

  bool message_handler::information(const std::string& id,
                                    const std::string& arg1,
                                    const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << information_message(id, arg1, arg2);
    return true;
  }

  bool message_handler::information(const std::string& id,
                                    const std::string& arg1,
                                    const std::string& arg2,
                                    const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << information_message(id, arg1, arg2, arg3);
    return true;
  }

  bool message_handler::information(const message_position& position,
                                    const std::string& id,
                                    const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << information_message(position, id, args);
    return true;
  }

  bool message_handler::information(const message_position& position,
                                    const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << information_message(position, id);
    return true;
  }

  bool message_handler::information(const message_position& position,
                                    const std::string& id,
                                    const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << information_message(position, id, arg1);
    return true;
  }

  bool message_handler::information(const message_position& position,
                                    const std::string& id,
                                    const std::string& arg1,
                                    const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << information_message(position, id, arg1, arg2);
    return true;
  }

  bool message_handler::information(const message_position& position,
                                    const std::string& id,
                                    const std::string& arg1,
                                    const std::string& arg2,
                                    const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << information_message(position, id, arg1, arg2, arg3);
    return true;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // warning messages

  bool message_handler::warning(const std::string& id,
                                const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << warning_message(id, args);
    return true;
  }

  bool message_handler::warning(const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << warning_message(id);
    return true;
  }

  bool message_handler::warning(const std::string& id,
                                const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << warning_message(id, arg1);
    return true;
  }

  bool message_handler::warning(const std::string& id,
                                const std::string& arg1,
                                const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << warning_message(id, arg1, arg2);
    return true;
  }

  bool message_handler::warning(const std::string& id,
                                const std::string& arg1,
                                const std::string& arg2,
                                const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << warning_message(id, arg1, arg2, arg3);
    return true;
  }

  bool message_handler::warning(const message_position& position,
                                const std::string& id,
                                const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << warning_message(position, id, args);
    return true;
  }

  bool message_handler::warning(const message_position& position,
                                const std::string& id)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << warning_message(position, id);
    return true;
  }

  bool message_handler::warning(const message_position& position,
                                const std::string& id,
                                const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << warning_message(position, id, arg1);
    return true;
  }

  bool message_handler::warning(const message_position& position,
                                const std::string& id,
                                const std::string& arg1,
                                const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << warning_message(position, id, arg1, arg2);
    return true;
  }

  bool message_handler::warning(const message_position& position,
                                const std::string& id,
                                const std::string& arg1,
                                const std::string& arg2,
                                const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error)
  {
    device() << warning_message(position, id, arg1, arg2, arg3);
    return true;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // error messages

  bool message_handler::error(const std::string& id,
                              const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error)
  {
    device() << error_message(id, args);
    m_body->error_increment();
    if (m_body->limit_reached()) throw message_handler_limit_error(m_body->limit());
    return false;
  }

  bool message_handler::error(const std::string& id)
    throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error)
  {
    device() << error_message(id);
    m_body->error_increment();
    if (m_body->limit_reached()) throw message_handler_limit_error(m_body->limit());
    return false;
  }

  bool message_handler::error(const std::string& id,
                              const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error)
  {
    device() << error_message(id, arg1);
    m_body->error_increment();
    if (m_body->limit_reached()) throw message_handler_limit_error(m_body->limit());
    return false;
  }

  bool message_handler::error(const std::string& id,
                              const std::string& arg1,
                              const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error)
  {
    device() << error_message(id, arg1, arg2);
    m_body->error_increment();
    if (m_body->limit_reached()) throw message_handler_limit_error(m_body->limit());
    return false;
  }

  bool message_handler::error(const std::string& id,
                              const std::string& arg1,
                              const std::string& arg2,
                              const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error)
  {
    device() << error_message(id, arg1, arg2, arg3);
    m_body->error_increment();
    if (m_body->limit_reached()) throw message_handler_limit_error(m_body->limit());
    return false;
  }

  bool message_handler::error(const message_position& position,
                              const std::string& id,
                              const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error)
  {
    device() << error_message(position, id, args);
    m_body->error_increment();
    if (m_body->limit_reached()) throw message_handler_limit_error(m_body->limit());
    return false;
  }

  bool message_handler::error(const message_position& position,
                              const std::string& id)
    throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error)
  {
    device() << error_message(position, id);
    m_body->error_increment();
    if (m_body->limit_reached()) throw message_handler_limit_error(m_body->limit());
    return false;
  }

  bool message_handler::error(const message_position& position,
                              const std::string& id,
                              const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error)
  {
    device() << error_message(position, id, arg1);
    m_body->error_increment();
    if (m_body->limit_reached()) throw message_handler_limit_error(m_body->limit());
    return false;
  }

  bool message_handler::error(const message_position& position,
                              const std::string& id,
                              const std::string& arg1,
                              const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error)
  {
    device() << error_message(position, id, arg1, arg2);
    m_body->error_increment();
    if (m_body->limit_reached()) throw message_handler_limit_error(m_body->limit());
    return false;
  }

  bool message_handler::error(const message_position& position,
                              const std::string& id,
                              const std::string& arg1,
                              const std::string& arg2,
                              const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error,message_handler_limit_error)
  {
    device() << error_message(position, id, arg1, arg2, arg3);
    m_body->error_increment();
    if (m_body->limit_reached()) throw message_handler_limit_error(m_body->limit());
    return false;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // fatal messages

  bool message_handler::fatal(const std::string& id,
                              const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error)
  {
    device() << fatal_message(id, args);
    throw message_handler_fatal_error(id);
  }

  bool message_handler::fatal(const std::string& id)
    throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error)
  {
    device() << fatal_message(id);
    throw message_handler_fatal_error(id);
  }

  bool message_handler::fatal(const std::string& id,
                              const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error)
  {
    device() << fatal_message(id, arg1);
    throw message_handler_fatal_error(id);
  }

  bool message_handler::fatal(const std::string& id,
                              const std::string& arg1,
                              const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error)
  {
    device() << fatal_message(id, arg1, arg2);
    throw message_handler_fatal_error(id);
  }

  bool message_handler::fatal(const std::string& id,
                              const std::string& arg1,
                              const std::string& arg2,
                              const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error)
  {
    device() << fatal_message(id, arg1, arg2, arg3);
    throw message_handler_fatal_error(id);
  }

  bool message_handler::fatal(const message_position& position,
                              const std::string& id,
                              const std::vector<std::string>& args)
    throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error)
  {
    device() << fatal_message(position, id, args);
    throw message_handler_fatal_error(id);
  }

  bool message_handler::fatal(const message_position& position,
                              const std::string& id)
    throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error)
  {
    device() << fatal_message(position, id);
    throw message_handler_fatal_error(id);
  }

  bool message_handler::fatal(const message_position& position,
                              const std::string& id,
                              const std::string& arg1)
    throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error)
  {
    device() << fatal_message(position, id, arg1);
    throw message_handler_fatal_error(id);
  }

  bool message_handler::fatal(const message_position& position,
                              const std::string& id,
                              const std::string& arg1,
                              const std::string& arg2)
    throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error)
  {
    device() << fatal_message(position, id, arg1, arg2);
    throw message_handler_fatal_error(id);
  }

  bool message_handler::fatal(const message_position& position,
                              const std::string& id,
                              const std::string& arg1,
                              const std::string& arg2,
                              const std::string& arg3)
    throw(message_handler_id_error,message_handler_format_error,message_handler_fatal_error)
  {
    device() << fatal_message(position, id, arg1, arg2, arg3);
    throw message_handler_fatal_error(id);
  }

  ///////////////////////////////////////////////////////////////////////////////
  // plain text

  bool message_handler::plaintext(const std::string& text)
  {
    device() << text << std::endl;
    return true;
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

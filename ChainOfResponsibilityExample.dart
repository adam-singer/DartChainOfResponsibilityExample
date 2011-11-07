#import('dart:dom');
// Simple example of how to do a chain of responsibility in dart.
// http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern
interface ILogger
{
  ILogger next;
  ILogger setNext(ILogger log);
  void message(String msg, int priority);
  void writeMessage(String msg);
}

class Logger implements ILogger {
  static int ERR = 3;
  static int NOTICE = 5;
  static int DEBUG = 7;
  
  int mask;
  
  ILogger next;
  
  ILogger setNext(ILogger log)
  {
    next = log;
    return log;
  }
  
  void message(String msg, int priority)
  {
    if (priority <= mask) {
      writeMessage(msg);
    }
    
    if (next != null) {
      next.message(msg, priority);
    }
  }
  
  abstract void writeMessage(String msg);
}

class StdoutLogger extends Logger {
  
  StdoutLogger(int mask) {
    this.mask = mask;
  }
  
  
  void writeMessage(String msg) { 
    print("StdoutLogger: " + msg);
  }
}

class EmailLogger extends Logger {
  EmailLogger(int mask) {
    this.mask = mask;
  }
  
  void writeMessage(String msg) {
    print("EmailLogger: " + msg);
  }  
}

class StderrLogger extends Logger {
  StderrLogger(int mask) {
    this.mask = mask;
  }
  
  void writeMessage(String msg) {
    print("StderrLogger: " + msg);
  }  
}

class HttpStdoutLogger extends Logger {
  HttpStdoutLogger(int mask) {
    this.mask = mask;
  }
  
  void writeMessage(String msg) {
    HTMLDocument doc = window.document;
    HTMLParagraphElement p = doc.createElement('p');
    p.innerText = msg;
    doc.body.appendChild(p);
  }
}

class ChainOfResponsibilityExample {

  ILogger logger, logger1;
  
  ChainOfResponsibilityExample() {
    logger1 = logger = new StdoutLogger(Logger.DEBUG);
    logger1 = logger1.setNext(new EmailLogger(Logger.NOTICE));
    logger1 = logger1.setNext(new HttpStdoutLogger(Logger.NOTICE));
    logger1 = logger1.setNext(new StderrLogger(Logger.ERR));
  }

  void run() {
    // Hello World
    logger.message("Hello World!", Logger.NOTICE);
    
    // Handled by StdoutLogger
    logger.message("Entering function y.", Logger.DEBUG);

    // Handled by StdoutLogger and EmailLogger
    logger.message("Step1 completed.", Logger.NOTICE);

    // Handled by all three loggers
    logger.message("An error has occurred.", Logger.ERR);
  }
}

void main() {
  new ChainOfResponsibilityExample().run();
}

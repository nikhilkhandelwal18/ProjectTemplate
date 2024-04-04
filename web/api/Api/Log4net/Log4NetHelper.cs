using log4net.Repository;
using log4net;

namespace Api.Log4net
{
    public static class Log4NetHelper
  {
    public static List<Log4NetAppender> GetLogFilePath()
    {
      ILoggerRepository repository = LogManager.GetRepository(typeof(Log4NetHelper).Assembly);
      var appenders = repository.GetAppenders();

      List<Log4NetAppender> log4NetAppenders = new List<Log4NetAppender>();

      foreach (var appender in appenders)
      {
        if (appender is log4net.Appender.FileAppender fileAppender)
        {
          log4NetAppenders.Add(new Log4NetAppender { LogFilePath = fileAppender.File, AppenderName = appender.Name });
          
          //return fileAppender.File;
        }
      }
      if (!log4NetAppenders.Any())
      {
        throw new InvalidOperationException("Log4net file appender not found in configuration.");
      }

      return log4NetAppenders;
    }
  }
}

using System.Diagnostics.CodeAnalysis;
using System.Reflection;
using Api.Interfaces;
using Api.Models;
using Api.Services;
using log4net;
using log4net.Config;
using Newtonsoft.Json;

namespace Api.Log4net
{
  public interface ILogger
  {
    void LogError(string message, Exception ex);
    void LogInfo(string message);
  }

  [ExcludeFromCodeCoverage]
  public class Logger : ILogger
  {
    private readonly IConfiguration? _configuration;
    public ILog? errorLogger;
    public ILog? businessLogger;
    public ILog? apiInfoLogger;


    public Logger(IConfiguration configuration)
    {
      _configuration = configuration;

      var logRepository = LogManager.GetRepository(Assembly.GetEntryAssembly());
    
      GlobalContext.Properties["AppName"] = _configuration["AppName"];
      GlobalContext.Properties["Environment"] = _configuration["Environment"];

      using (StreamReader r = new("buildinfoAPI.json"))
      {
        string json = r.ReadToEnd();
        if (!string.IsNullOrEmpty(json))
        {
          GitBuildInfo? buildInfo = JsonConvert.DeserializeObject<GitBuildInfo?>(json);
          GlobalContext.Properties["Pipeline"] = buildInfo!.Pipeline;
          GlobalContext.Properties["Repository"] = buildInfo!.Repository;
          GlobalContext.Properties["Branch"] = buildInfo!.Branch;
          GlobalContext.Properties["BuildNumber"] = buildInfo!.BuildNumber;
        }       
      }
      
      XmlConfigurator.Configure(logRepository, new FileInfo(configuration["Log4NetFile"]!));

      errorLogger = LogManager.GetLogger(configuration["LogAppender:ErrorAppender"]);
      businessLogger = LogManager.GetLogger(configuration["LogAppender:BusinessAppender"]);
      apiInfoLogger = LogManager.GetLogger(configuration["LogAppender:ApiInfoAppender"]);
    }

    public void LogError(string message, Exception ex)
    {
      errorLogger?.Error(message, ex);
    }

    public void LogInfo(string message)
    {
      businessLogger?.Info($"{DateTime.Now} | {message}");
    }


  }
}

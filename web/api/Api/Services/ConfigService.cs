using Api.Interfaces;
using Api.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace Api.Services
{
  public class ConfigService : IConfigService
  {
    private readonly Log4net.ILogger _logger;
   
    public ConfigService(Log4net.ILogger logger)
    {
      _logger = logger;
    }

    public GitBuildInfo GetBuildInfo()
    {
      try
      {
        GitBuildInfo? buildInfo = new();
        using (StreamReader r = new("buildinfoAPI.json"))
        {
          string json = r.ReadToEnd();
          if (!string.IsNullOrEmpty(json))
          {
            buildInfo = JsonConvert.DeserializeObject<GitBuildInfo>(json);
          }
        }
        return buildInfo ?? new GitBuildInfo();
      }
      catch (Exception ex)
      {
        _logger.LogError(ex.Message, ex);
        throw;
      }
    }
  }
}

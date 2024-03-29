using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Api.Models;
using Newtonsoft.Json;
using Api.Interfaces;

namespace Api.Controllers
{
  [Route("[controller]")]
  [ApiController]
  [Authorize]
  public class ConfigController : ControllerBase
  {
    private readonly IConfiguration _configuration;
    private readonly Log4net.ILogger _logger;
    private readonly IConfigService _configService;


    public ConfigController(IConfiguration configuration, Log4net.ILogger log4netlogger, IConfigService configService )
    {
      _configuration = configuration;
      _logger = log4netlogger;
      _configService = configService;

    }

    /// <summary>
    /// Get Application specific settings
    /// </summary>
    /// <param name="appName"></param>
    /// <returns></returns>
    [AllowAnonymous]
    [HttpGet("[Action]")]
    public ActionResult<string> GetHostEnvironment(string? appName)
    {
      _logger.LogInfo($"GetHostEnvironment || {appName}");
      var hostEnvironment = _configuration.GetValue<string>("Environment");
      return new JsonResult(new { hostEnvironment });
    }

    /// <summary>
    /// Get build information
    /// </summary>
    /// <returns></returns>
    [AllowAnonymous]
    [HttpGet("[Action]")]
    public ActionResult<GitBuildInfo> GetBuildInfo()
    {
      try
      {
        GitBuildInfo buildInfo = _configService.GetBuildInfo();
        return Ok(buildInfo);
      }
      catch (Exception ex)
      {
        _logger.LogError(ex.Message, ex);
        return BadRequest(ex.Message);
      }
    }
  }
}

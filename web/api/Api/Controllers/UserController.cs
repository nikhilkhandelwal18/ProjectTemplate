using Microsoft.AspNetCore.Authentication;
using System.Security.Principal;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Api.Models;
using System.DirectoryServices.AccountManagement;
using System.Runtime.Versioning;
using Api.Services;
using Api.Interfaces;

namespace Api.Controllers
{
  [SupportedOSPlatform("windows")]
  [Route("[controller]")]
  [ApiController]
  public class UserController : ControllerBase
  {
    private readonly Log4net.ILogger _logger;
    private readonly IUserService _userService;

    public UserController(Log4net.ILogger logger, IUserService userService)
    {
      _logger = logger;
      _userService = userService;
    }

    [HttpGet]
    public ActionResult<User> GetUserInfo()
    {
      _logger.LogInfo("User/GetUserInfo");
      try
      {
        var user = _userService.GetUserInfoAsync().Result;

        if (user != null)
        {
          _logger.LogInfo($"User: {user.UserId}");
          return Ok(user);
        }
        else
        {
          return NotFound();
        }
      }
      catch (Exception ex)
      {
        _logger.LogError(ex.Message, ex);
        return StatusCode(500, "An error occurred while processing your request.");
      }
    }
  }
}

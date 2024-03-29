using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.Runtime.Versioning;
using System.Security.Principal;
using Api.Interfaces;
using Api.Models;

namespace Api.Services
{
  [SupportedOSPlatform("windows")]
  public class UserService : IUserService
  {
    private readonly Log4net.ILogger _logger;
    private readonly IConfiguration _configuration;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public UserService(Log4net.ILogger logger, IConfiguration configuration, IHttpContextAccessor httpContextAccessor)
    {
      _logger = logger;
      _configuration = configuration;
      _httpContextAccessor = httpContextAccessor;
    }

    public async Task<User> GetUserInfoAsync()
    {
      try
      {
        var httpContext = _httpContextAccessor.HttpContext;
        WindowsPrincipal wp = new WindowsPrincipal(WindowsIdentity.GetCurrent());

        User user = new();

        if (httpContext != null)
        {
          using (var windowsIdentity = httpContext.User.Identity as WindowsIdentity)
          {
            if (windowsIdentity?.IsAuthenticated == true)
            {
              using (var context = new PrincipalContext(ContextType.Domain))
              {
                var userPrincipal = await Task.Run(() => UserPrincipal.FindByIdentity(context, windowsIdentity.Name)).ConfigureAwait(false);

                if (userPrincipal != null)
                {
                  string[] userID = windowsIdentity.Name.Split(new[] { '\\' }, StringSplitOptions.None);

                  var extensionAttribute3 = (userPrincipal.GetUnderlyingObject() as DirectoryEntry)?.Properties["extensionAttribute3"].Value as string;
                  var initials = (userPrincipal.GetUnderlyingObject() as DirectoryEntry)?.Properties["initials"].Value as string;

                  user = new User()
                  {
                    UserId = userID.Length > 1 ? userID[1] : userID[0],
                    FirstName = userPrincipal.GivenName,
                    MiddleName = initials,
                    LastName = userPrincipal.Surname,
                    DisplayName = userPrincipal.DisplayName,
                    Description = userPrincipal.Description,
                    EmailAddress = userPrincipal.EmailAddress,
                    ExtensionAttribute3 = extensionAttribute3
                  };
                }
              }
            }
          }
        }

        _logger.LogInfo($"User: {user.UserId}");
        return user;
      }
      catch (Exception ex)
      {
        _logger.LogError(ex.Message, ex);
        throw;
      }
    }

  }
}

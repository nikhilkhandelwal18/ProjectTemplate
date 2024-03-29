using Api.Models;

namespace Api.Interfaces
{
  public interface IUserService
  {
     Task<User> GetUserInfoAsync();
  }
}

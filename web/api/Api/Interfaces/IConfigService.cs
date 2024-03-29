using Api.Models;

namespace Api.Interfaces
{
  public interface IConfigService
  {
    GitBuildInfo GetBuildInfo();
  }
}

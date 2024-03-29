namespace Api.Models
{
  public class GitBuildInfo
  {
    public string? Application { get; set; }
    public string? Repository { get; set; }
    public string? Branch { get; set; }
    public string? Pipeline { get; set; }
    public string? BuildNumber { get; set; }
  }
}

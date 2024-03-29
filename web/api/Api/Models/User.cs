namespace Api.Models
{
  public class User
  {
    public string? UserId { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? DisplayName { get; set; }
    public string? Description { get; set; }
    public string? MiddleName { get; internal set; }
    public object EmailAddress { get; internal set; }
    public string? ExtensionAttribute3 { get; internal set; }
  }
}

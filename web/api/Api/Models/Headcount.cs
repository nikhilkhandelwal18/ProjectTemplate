namespace Api.Models
{
  public class Headcount
  {
    public string? Division { get; set; }
    public string? Location { get; set; }
    public string? Position { get; set; }
    public int? Authorized { get; set; }
    public int? Actual { get; set; }
    public int? Delta { get; set; }
  }
}

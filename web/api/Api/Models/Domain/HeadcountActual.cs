using System.Text.Json.Serialization;

namespace Api.Models.Domain
{
  public class HeadcountActual
  {
    [JsonPropertyName("management_center")]
    public string? ManagementCenter { get; set; }

    [JsonPropertyName("job_class")]
    public string? JobClass { get; set; }

    [JsonPropertyName("actual")]
    public decimal? Actual { get; set; }
  }
}

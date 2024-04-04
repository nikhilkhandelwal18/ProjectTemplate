namespace Api.Log4net
{
  public class Log4NetAppender
  {
    public string? Name { get; set; }
    public string? AppenderName { get; set; }
    public string? LogFilePath { get; set; }
    public bool? FilePathExists { get; set; }
  }
}

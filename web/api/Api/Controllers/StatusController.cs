using Api.Log4net;
using Api.Models.Status;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net.NetworkInformation;

namespace Api.Controllers
{
  [Route("[controller]")]
  [ApiController]
  public class StatusController : ControllerBase
  {
    private readonly Log4net.ILogger _logger;
    private readonly IConfiguration _configuration;

    public StatusController(Log4net.ILogger logger, IConfiguration configuration)
    {
      _logger = logger;
      _configuration = configuration;

      _logger.LogInfo("STATUS CONTROLLER");
    }

    [HttpGet]
    [Route("apistatus")]
    public IActionResult GetApiStatus()
    {
      _logger.LogInfo("API status checked");
      return Ok("API is up and running");
    }

    [HttpGet]
    [Route("log4net")]
    public IActionResult CheckLog4netFile()
    {
      List<Log4NetAppender> logFilePath = Log4NetHelper.GetLogFilePath();
      Console.WriteLine("Log file path: " + logFilePath);

      if (logFilePath.Count > 0)
      {

        foreach (Log4NetAppender log in logFilePath)
        {
          log.FilePathExists = System.IO.File.Exists(log.LogFilePath);
          log.Name = System.IO.Path.GetFileName(log.LogFilePath);
        }

        return Ok(logFilePath);
      }
      else
      {
        return NoContent();
      }

    }

    [HttpGet]
    [Route("dbconnection")]
    public IActionResult CheckConnectionStrings()
    {
      var connectionStrings = _configuration.GetSection("ConnectionStrings").GetChildren();
      var connectionResults = new List<ConnectionResult>();

      foreach (var connectionString in connectionStrings)
      {
        var connString = connectionString.Value;
      
        try
        {
          using (var connection = new SqlConnection(connString))
          {
            connection.Open();
            connectionResults.Add(new ConnectionResult
            {
              Server = connection.DataSource,
              Database = connection.Database,
              State = connection.State == ConnectionState.Open ? "Pass" : "Failed"
            }); ;
            connection.Close();
          }
        }
        catch (SqlException ex)
        {
          var builder = new SqlConnectionStringBuilder(connString);
          connectionResults.Add(new ConnectionResult
          {
            Server = builder.DataSource,
            Database = builder.InitialCatalog,
            State = "Failed"
          });
        }
        catch (Exception ex)
        {
          connectionResults.Add(new ConnectionResult
          {
            Server = "",
            Database = "",
            State = ex.Message
          });
        }
      }

      return Ok(connectionResults);
    }
  }
}

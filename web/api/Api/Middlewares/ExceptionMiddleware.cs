using System.Net;

namespace Api.Middlewares
{
  public class ExceptionMiddleware
  {
    private readonly RequestDelegate _next;
    private readonly Log4net.ILogger _log4netlogger;

    public ExceptionMiddleware(RequestDelegate next, Log4net.ILogger log4netlogger)
    {
      _next = next;
      _log4netlogger = log4netlogger;
    }

    public async Task InvokeAsync(HttpContext httpContext)
    {
      try
      {
        await _next(httpContext);
      }
      catch (Exception ex)
      {
        _log4netlogger.LogError(ex.Message, ex);
        HandleExceptionAsync(httpContext);
      }
    }

    private static void HandleExceptionAsync(HttpContext context)
    {
      context.Response.ContentType = "application/json";
      context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;

      //await Task.FromResult();
    }
  }
}

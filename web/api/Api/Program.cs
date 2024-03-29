using Microsoft.AspNetCore.Authentication.Negotiate;
using Microsoft.AspNetCore.HttpOverrides;
using Api.Interfaces;
using Api.Middlewares;
using Api.Services;

namespace Api
{
  public class Program
  {
    public static void Main(string[] args)
    {
      var builder = WebApplication.CreateBuilder(args);

      // Add services to the container.
      builder.Services.AddHttpContextAccessor();

      builder.Services.AddControllers();

      builder.Services.AddAuthentication(NegotiateDefaults.AuthenticationScheme).AddNegotiate();

      builder.Services.AddAuthorization(options =>
      {
        // By default, all incoming requests will be authorized according to the default policy.
        options.FallbackPolicy = options.DefaultPolicy;
      });


      string? AllowedOrigins = builder.Configuration["AllowedOrigins"];
      string[]? withOrigins = null; 
      if(!string.IsNullOrWhiteSpace( AllowedOrigins))
      {
        withOrigins = AllowedOrigins.Split(';');
      }
      builder.Services.AddCors(options =>
      {
        options.AddPolicy("CorsPolicy",
                builder =>
                {
                  builder
                  .WithOrigins(withOrigins ?? new string[] { "http://localhost:3000", "http://127.0.0.1:3000" })
                  .AllowAnyHeader()
                  .AllowAnyMethod()
                  .AllowCredentials();
                });
      });

      builder.Services.AddSwaggerGen();

      //Service Registration
      builder.Services.AddSingleton<Log4net.ILogger, Log4net.Logger>();
      //application services
      builder.Services.AddScoped<IConfigService, ConfigService>();
      builder.Services.AddScoped<IUserService, UserService>();

      var app = builder.Build();
      app.UseForwardedHeaders(new ForwardedHeadersOptions { ForwardedHeaders = ForwardedHeaders.All });
   
      app.UseHttpsRedirection();

      app.UseMiddleware<ExceptionMiddleware>();

      app.UseAuthentication(); // Use authentication before CORS
      app.UseAuthorization();

      app.UseCors("CorsPolicy");


      app.UseSwagger();
      app.UseSwaggerUI();

      app.MapControllers();

      app.Run();
    }
  }
}

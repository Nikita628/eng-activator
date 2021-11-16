using EngActivator.APP.Shared.Dtos;
using EngActivator.APP.Shared.Exceptions;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Net;
using System.Text.Json;
using System.Threading.Tasks;

namespace EngActivator.API.Middleware
{
    public class ErrorHandler
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ErrorHandler> _logger;
        private readonly IHostEnvironment _env;
        private static readonly JsonSerializerOptions options = new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        };

        public ErrorHandler(RequestDelegate next, ILogger<ErrorHandler> logger, IHostEnvironment env)
        {
            _next = next;
            _logger = logger;
            _env = env;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            ErrorResponse response = null;

            try
            {
                await _next(context);
            }
            catch (AppNotFoundException notFoundEx)
            {
                response = new ErrorResponse(notFoundEx.Message);

                await ProcessErrorResponse(context, notFoundEx, HttpStatusCode.NotFound, response);
            }
            catch (AppErrorResponseException appEx)
            {
                response = appEx.ErrorResponse;

                await ProcessErrorResponse(context, appEx, HttpStatusCode.BadRequest, response);
            }
            catch (AppUnauthorizedException un)
            {
                response = new ErrorResponse(un.Message);

                await ProcessErrorResponse(context, un, HttpStatusCode.Unauthorized, response);
            }
            catch (Exception ex)
            {
                var errorMessage = "Something went wrong";

                if (_env.EnvironmentName == "Local" || _env.EnvironmentName == "Development")
                {
                    errorMessage = ex.Message;
                }

                response = new ErrorResponse(errorMessage);

                await ProcessErrorResponse(context, ex, HttpStatusCode.InternalServerError, response);
            }
        }

        private async Task ProcessErrorResponse(HttpContext context, Exception ex, HttpStatusCode code, ErrorResponse response)
        {
            _logger.LogError(ex, ex.Message);

            if (_env.EnvironmentName == "Local" || _env.EnvironmentName == "Development")
            {
                response.Details = ex.StackTrace.ToString();

                if (ex.InnerException != null)
                {
                    response.Message += $"\ninner exception: {ex.InnerException.Message}\n{ex.InnerException.StackTrace}";
                }
            }

            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)code;

            var json = JsonSerializer.Serialize(response, options);

            await context.Response.WriteAsync(json);
        }
    }
}

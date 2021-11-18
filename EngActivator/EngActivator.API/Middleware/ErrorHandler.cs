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

                await SendBackErrorResponse(context, notFoundEx, HttpStatusCode.NotFound, response);
            }
            catch (AppErrorResponseException appEx)
            {
                response = appEx.ErrorResponse;

                await SendBackErrorResponse(context, appEx, HttpStatusCode.BadRequest, response);
            }
            catch (AppUnauthorizedException un)
            {
                response = new ErrorResponse(un.Message);

                await SendBackErrorResponse(context, un, HttpStatusCode.Unauthorized, response);
            }
            catch (Exception ex)
            {
                var errorMessage = "Something went wrong";

                if (_env.EnvironmentName == "Local" || _env.EnvironmentName == "Development")
                {
                    errorMessage = ex.Message;
                }

                response = new ErrorResponse(errorMessage);

                await SendBackErrorResponse(context, ex, HttpStatusCode.InternalServerError, response);
            }
        }

        private async Task SendBackErrorResponse(HttpContext context, Exception occuredException, HttpStatusCode code, ErrorResponse response)
        {
            _logger.LogError(occuredException, occuredException.Message);

            if (occuredException.InnerException != null)
            {
                _logger.LogError(occuredException.InnerException, occuredException.InnerException.Message);
            }

            if (_env.EnvironmentName == "Local" || _env.EnvironmentName == "Development")
            {
                response.Details = occuredException.StackTrace.ToString();

                if (occuredException.InnerException != null)
                {
                    response.Details += $"\n---INNER EXCEPTION---: {occuredException.InnerException.Message}\n{occuredException.InnerException.StackTrace}";
                }
            }

            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)code;

            var json = JsonSerializer.Serialize(response, options);

            await context.Response.WriteAsync(json);
        }
    }
}

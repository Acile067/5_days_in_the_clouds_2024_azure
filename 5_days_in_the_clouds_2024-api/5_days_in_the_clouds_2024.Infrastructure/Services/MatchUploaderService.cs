using _5_days_in_the_clouds_2024.Domain.Contracts;
using _5_days_in_the_clouds_2024.Domain.Entities;
using Microsoft.Extensions.Configuration;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace _5_days_in_the_clouds_2024.Infrastructure.Services
{
    public class MatchUploaderService : IMatchUploaderService
    {
        private readonly HttpClient _httpClient;
        private readonly string? _functionUrl;

        public MatchUploaderService(HttpClient httpClient, IConfiguration configuration)
        {
            _httpClient = httpClient ?? throw new ArgumentNullException(nameof(httpClient));
            _functionUrl = configuration["ExternalServices:MatchUploadFunctionUrl"];
        }
        public async Task UploadMatchAsync(Match match)
        {
            var json = JsonSerializer.Serialize(match);
            var content = new StringContent(json, Encoding.UTF8, "application/json");
            await _httpClient.PostAsync(_functionUrl, content);
        }
    }
}

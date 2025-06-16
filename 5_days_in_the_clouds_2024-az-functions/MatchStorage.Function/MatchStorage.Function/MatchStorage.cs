using Azure.Storage.Blobs;
using MatchStorage.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace MatchStorage.Function
{
    public class MatchStorage
    {
        private readonly IBuiltRequestProcessor _builtRequestProcessor;
        public MatchStorage(IBuiltRequestProcessor builtRequestProcessor) 
        { 
            _builtRequestProcessor = builtRequestProcessor ?? throw new ArgumentNullException(nameof(builtRequestProcessor));
        }

        [FunctionName("MatchStorage")]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "foo")] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("Azure Function MatchStorage triggered.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            var match = JsonConvert.DeserializeObject<Match>(requestBody);

            if (match == null)
            {
                return new BadRequestObjectResult("Invalid Match data.");
            }

            // Serijalizuj Match kao JSON string
            var matchJson = JsonConvert.SerializeObject(match, Formatting.Indented);

            // Upload u Blob Storage
            var connectionString = Environment.GetEnvironmentVariable("AzureWebJobsStorage"); // ili tvoj custom env var
            var containerName = "matches"; // mora biti već kreiran, ili koristi BlobContainerClient.CreateIfNotExistsAsync()

            var blobServiceClient = new BlobServiceClient(connectionString);
            var containerClient = blobServiceClient.GetBlobContainerClient(containerName);
            await containerClient.CreateIfNotExistsAsync();

            var blobName = $"match-{match.Id}.json";
            var blobClient = containerClient.GetBlobClient(blobName);

            using var stream = new MemoryStream(Encoding.UTF8.GetBytes(matchJson));
            await blobClient.UploadAsync(stream, overwrite: true);

            log.LogInformation($"Match uploaded as {blobName}.");

            return new OkObjectResult($"Match stored in blob: {blobName}");
        }
    }
}

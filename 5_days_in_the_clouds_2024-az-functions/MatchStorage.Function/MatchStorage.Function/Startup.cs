using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using System;
using Microsoft.Extensions.DependencyInjection;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MatchStorage.Services;
using MatchStorage.Services.Interfaces;

[assembly: FunctionsStartup(typeof(MatchStorage.Function.Startup))]

namespace MatchStorage.Function
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            builder.Services.AddSingleton<IBuiltRequestProcessor, BuiltRequestProcessor>();
        }
    }
}

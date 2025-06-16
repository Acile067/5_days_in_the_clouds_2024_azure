using MatchStorage.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MatchStorage.Services
{
    public class BuiltRequestProcessor : IBuiltRequestProcessor
    {
        public async Task<int> DoSomethingAsync()
        {
            return 5; // Simulating some asynchronous operation
        }
    }
}

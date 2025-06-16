using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MatchStorage.Services.Interfaces
{
    public interface IBuiltRequestProcessor
    {
        Task<int> DoSomethingAsync();
    }
}

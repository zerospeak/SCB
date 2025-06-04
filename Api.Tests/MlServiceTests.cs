using System.Threading.Tasks;
using Xunit;
using Api.Controllers;

namespace Api.Tests
{
    public class MlServiceTests
    {
        [Fact]
        public async Task DummyMlService_ReturnsFixedScore()
        {
            var mlService = new DummyMlService();
            var claim = new Claim { ProviderID = "P1", MemberSSN = "123", PaidAmount = 100, IsFraud = null };
            var score = await mlService.Predict(claim);
            Assert.Equal(0.5, score);
        }
    }
}

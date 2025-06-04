using System.Threading.Tasks;
using Xunit;
using Moq;
using Api.Controllers;
using Microsoft.AspNetCore.Mvc;

namespace Api.Tests
{
    public class ClaimsControllerTests
    {
        [Fact]
        public async Task AnalyzeClaim_ReturnsRiskScore()
        {
            // Arrange
            var mockMlService = new Mock<IMlService>();
            mockMlService.Setup(s => s.Predict(It.IsAny<Claim>())).ReturnsAsync(0.8);
            var controller = new ClaimsController(mockMlService.Object);
            var claim = new Claim { ProviderID = "P1", MemberSSN = "123", PaidAmount = 100, IsFraud = null };

            // Act
            var result = await controller.AnalyzeClaim(claim) as OkObjectResult;

            // Assert
            Assert.NotNull(result);
            Assert.Equal(200, result.StatusCode ?? 200);
            Assert.Contains("risk", result.Value.ToString());
        }
    }
}

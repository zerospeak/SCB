using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Api;
using Api.Controllers;
using Xunit;

public class ClaimsControllerEfCoreTests
{
    private ClaimsDbContext GetInMemoryDbContext()
    {
        var options = new DbContextOptionsBuilder<ClaimsDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new ClaimsDbContext(options);
    }

    private ClaimsController GetController(ClaimsDbContext db)
    {
        return new ClaimsController(new DummyMlService(), db);
    }

    [Fact]
    public async Task Can_Create_And_Get_Claim()
    {
        var db = GetInMemoryDbContext();
        var controller = GetController(db);
        var claim = new Claim { ProviderID = "P1", MemberSSN = "123", PaidAmount = 100 };
        var result = await controller.AnalyzeClaim(claim);
        Assert.IsType<OkObjectResult>(result);
        var getResult = controller.GetClaimHistory() as OkObjectResult;
        Assert.NotNull(getResult);
        var claims = getResult.Value as System.Collections.Generic.List<Claim>;
        Assert.Single(claims);
        Assert.Equal("P1", claims[0].ProviderID);
    }

    [Fact]
    public async Task Can_Update_Claim()
    {
        var db = GetInMemoryDbContext();
        var controller = GetController(db);
        var claim = new Claim { ProviderID = "P2", MemberSSN = "456", PaidAmount = 200 };
        await controller.AnalyzeClaim(claim);
        var created = await db.Claims.FirstAsync();
        created.PaidAmount = 300;
        var updateResult = await controller.UpdateClaim(created.Id, created);
        Assert.IsType<OkObjectResult>(updateResult);
        var updated = await db.Claims.FindAsync(created.Id);
        Assert.Equal(300, updated.PaidAmount);
    }

    [Fact]
    public async Task Can_Delete_Claim()
    {
        var db = GetInMemoryDbContext();
        var controller = GetController(db);
        var claim = new Claim { ProviderID = "P3", MemberSSN = "789", PaidAmount = 400 };
        await controller.AnalyzeClaim(claim);
        var created = await db.Claims.FirstAsync();
        var deleteResult = await controller.DeleteClaim(created.Id);
        Assert.IsType<NoContentResult>(deleteResult);
        Assert.Empty(db.Claims);
    }
}

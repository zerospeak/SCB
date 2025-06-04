using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    //[Authorize(Policy = "HIPAA")]
    [AllowAnonymous]
    public class ClaimsController : ControllerBase
    {
        private readonly IMlService _mlService;
        private readonly Api.ClaimsDbContext _db;

        public ClaimsController(IMlService mlService, Api.ClaimsDbContext db)
        {
            _mlService = mlService;
            _db = db;
        }

        [HttpPost]
        public async Task<IActionResult> AnalyzeClaim([FromBody] Api.Claim claim)
        {
            if (string.IsNullOrWhiteSpace(claim.ProviderID) || string.IsNullOrWhiteSpace(claim.MemberSSN) || claim.PaidAmount <= 0)
            {
                return BadRequest("Invalid claim data. All fields are required and PaidAmount must be positive.");
            }
            var riskScore = await _mlService.Predict(claim);
            claim.Risk = riskScore;
            claim.Timestamp = DateTime.UtcNow;
            _db.Claims.Add(claim);
            await _db.SaveChangesAsync();
            return Ok(new { risk = riskScore });
        }

        [HttpGet("history")]
        public IActionResult GetClaimHistory()
        {
            // Return the last 20 claims from the database
            return Ok(_db.Claims.OrderByDescending(c => c.Timestamp).Take(20).ToList());
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetClaim(int id)
        {
            var claim = await _db.Claims.FindAsync(id);
            if (claim == null) return NotFound();
            return Ok(claim);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateClaim(int id, [FromBody] Api.Claim updated)
        {
            var claim = await _db.Claims.FindAsync(id);
            if (claim == null) return NotFound();
            claim.ProviderID = updated.ProviderID;
            claim.MemberSSN = updated.MemberSSN;
            claim.PaidAmount = updated.PaidAmount;
            claim.IsFraud = updated.IsFraud;
            claim.Risk = updated.Risk;
            claim.Timestamp = updated.Timestamp;
            await _db.SaveChangesAsync();
            return Ok(claim);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteClaim(int id)
        {
            var claim = await _db.Claims.FindAsync(id);
            if (claim == null) return NotFound();
            _db.Claims.Remove(claim);
            await _db.SaveChangesAsync();
            return NoContent();
        }

        [HttpPost("generate-demo-claims")]
        public async Task<IActionResult> GenerateDemoClaims([FromQuery] int count = 20)
        {
            var random = new Random();
            string[] providers = { "P100", "P200", "P300", "P400" };
            string[] ssns = { "123-45-6789", "987-65-4321", "555-55-5555", "111-22-3333" };
            for (int i = 0; i < count; i++)
            {
                var paid = Math.Round((decimal)(random.NextDouble() * 10000 + 100), 2);
                var risk = random.NextDouble();
                _db.Claims.Add(new Api.Claim
                {
                    ProviderID = providers[random.Next(providers.Length)],
                    MemberSSN = ssns[random.Next(ssns.Length)],
                    PaidAmount = paid,
                    Risk = risk,
                    Timestamp = DateTime.UtcNow.AddMinutes(-random.Next(0, 1000))
                });
            }
            await _db.SaveChangesAsync();
            return Ok(new { added = count });
        }
    }

    // Placeholder for ML service interface
    public interface IMlService
    {
        Task<double> Predict(Api.Claim claim);
    }
}

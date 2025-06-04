using Microsoft.AspNetCore.Mvc;

namespace Api.Controllers
{
    [ApiController]
    [Route("agent-health")]
    public class AgentHealthController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get() => Ok(new { status = "Agent Healthy", time = System.DateTime.UtcNow });
    }
}

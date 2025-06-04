using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Identity;
using Api.Controllers;

var builder = WebApplication.CreateBuilder(args);

// JWT config (use environment variables for secrets; fallback to dev values)
var jwtKey = Environment.GetEnvironmentVariable("JWT_KEY") ?? "dev_secret_key_1234567890_32bytes!!";
var jwtIssuer = Environment.GetEnvironmentVariable("JWT_ISSUER") ?? "HealthGuardDev";
var jwtAudience = Environment.GetEnvironmentVariable("JWT_AUDIENCE") ?? "HealthGuardAudience";
var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
// Add CORS for frontend (all three frontends for dev)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend",
        policy => policy
            .WithOrigins(
                "http://localhost:5000", // Swagger UI
                "http://localhost:5002", // Blazor WASM
                "http://localhost:5003", // Angular
                "http://localhost:5004"  // React
            )
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials());
});
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtIssuer,
        ValidAudience = jwtAudience,
        IssuerSigningKey = signingKey
    };
});
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("HIPAA", policy => policy.RequireAuthenticatedUser());
});
// Register EF Core DbContext and Identity
builder.Services.AddDbContext<Api.ClaimsDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("ClaimsDb") ??
        "Server=tcp:localhost,1433;Database=ClaimsDb;User Id=sa;Password=YourStrong!Passw0rd;TrustServerCertificate=True;"));
builder.Services.AddIdentity<IdentityUser, IdentityRole>()
    .AddEntityFrameworkStores<Api.ClaimsDbContext>()
    .AddDefaultTokenProviders();
// Register ML service (DummyMlService is for dev/demo only; replace with real ML service for production)
builder.Services.AddScoped<IMlService, DummyMlService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
// Always enable Swagger for dev/demo
app.UseSwagger();
app.UseSwaggerUI();

// Use CORS for frontend
app.UseCors("AllowFrontend");

app.UseAuthentication();
app.UseAuthorization();

// Add a /login endpoint that validates credentials and returns a JWT
app.MapPost("/login", [Microsoft.AspNetCore.Authorization.AllowAnonymous] async ([FromBody] LoginRequest req, UserManager<IdentityUser> userManager, SignInManager<IdentityUser> signInManager, ILoggerFactory loggerFactory) =>
{
    var logger = loggerFactory.CreateLogger("Login");
    logger.LogInformation($"Login attempt for user: {req.Username}");
    var user = await userManager.FindByNameAsync(req.Username);
    if (user != null && await userManager.CheckPasswordAsync(user, req.Password))
    {
        logger.LogInformation($"Login success for user: {req.Username}");
        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.Name, req.Username),
            new Claim(ClaimTypes.NameIdentifier, user.Id)
        };
        var roles = await userManager.GetRolesAsync(user);
        claims.AddRange(roles.Select(r => new Claim(ClaimTypes.Role, r)));
        var token = new JwtSecurityToken(
            issuer: jwtIssuer,
            audience: jwtAudience,
            claims: claims,
            expires: DateTime.UtcNow.AddHours(8),
            signingCredentials: new SigningCredentials(signingKey, SecurityAlgorithms.HmacSha256)
        );
        var jwt = new JwtSecurityTokenHandler().WriteToken(token);
        return Results.Ok(new { token = jwt });
    }
    logger.LogWarning($"Login failed for user: {req.Username}");
    return Results.Unauthorized();
});

// Dev-only: force re-seed admin user and role (do not expose in production)
app.MapPost("/seed-admin", [Microsoft.AspNetCore.Authorization.AllowAnonymous] async (UserManager<IdentityUser> userManager, RoleManager<IdentityRole> roleManager) =>
{
    if (!await roleManager.RoleExistsAsync("Admin"))
    {
        await roleManager.CreateAsync(new IdentityRole("Admin"));
    }
    var adminUser = await userManager.FindByNameAsync("admin");
    if (adminUser == null)
    {
        adminUser = new IdentityUser { UserName = "admin", Email = "admin@example.com", EmailConfirmed = true };
        await userManager.CreateAsync(adminUser, "Admin!234");
    }
    if (!await userManager.IsInRoleAsync(adminUser, "Admin"))
    {
        await userManager.AddToRoleAsync(adminUser, "Admin");
    }
    return Results.Ok(new { message = "Admin user and role seeded.", username = "admin", password = "Admin!234" });
});

app.MapControllers();

// Ensure EF Core migrations are applied and seed admin user
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    Api.DbContextMigrate.EnsureMigration(app);
    // Seed admin user
    var userManager = services.GetRequiredService<UserManager<IdentityUser>>();
    var roleManager = services.GetRequiredService<RoleManager<IdentityRole>>();
    if (!await roleManager.RoleExistsAsync("Admin"))
    {
        await roleManager.CreateAsync(new IdentityRole("Admin"));
    }
    var adminUser = await userManager.FindByNameAsync("admin");
    if (adminUser == null)
    {
        adminUser = new IdentityUser { UserName = "admin", Email = "admin@example.com", EmailConfirmed = true };
        await userManager.CreateAsync(adminUser, "Admin!234");
        await userManager.AddToRoleAsync(adminUser, "Admin");
    }
}

app.Run();

public record LoginRequest(string Username, string Password);

// Dummy ML service implementation (for dev/demo only)
public class DummyMlService : IMlService
{
    public Task<double> Predict(Api.Claim claim)
    {
        // Simple demo logic: High paid amount = high risk, otherwise low risk
        if (claim.PaidAmount > 5000)
            return Task.FromResult(0.9); // High risk
        return Task.FromResult(0.1); // Low risk
    }
}

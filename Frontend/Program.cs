using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using Frontend;
using Frontend.Shared;
using Microsoft.JSInterop;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

// Register AuthService
builder.Services.AddScoped<AuthService>();

// Configure HttpClient to attach JWT
builder.Services.AddScoped(sp =>
{
    var js = sp.GetRequiredService<IJSRuntime>();
    var auth = sp.GetRequiredService<AuthService>();
    var client = new HttpClient(new JwtMessageHandler(auth, js))
    {
        BaseAddress = new Uri(builder.HostEnvironment.BaseAddress)
    };
    return client;
});

await builder.Build().RunAsync();

// DelegatingHandler to attach JWT
public class JwtMessageHandler : DelegatingHandler
{
    private readonly AuthService _auth;
    private readonly IJSRuntime _js;
    public JwtMessageHandler(AuthService auth, IJSRuntime js)
    {
        _auth = auth;
        _js = js;
        InnerHandler = new HttpClientHandler();
    }
    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        var token = await _auth.GetToken();
        if (!string.IsNullOrEmpty(token))
        {
            request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);
        }
        return await base.SendAsync(request, cancellationToken);
    }
}

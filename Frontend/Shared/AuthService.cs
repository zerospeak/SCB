using System.Net.Http;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Microsoft.JSInterop;

namespace Frontend.Shared
{
    public class AuthService
    {
        private readonly HttpClient _http;
        private readonly IJSRuntime _js;
        private const string TokenKey = "jwt_token";
        public AuthService(HttpClient http, IJSRuntime js)
        {
            _http = http;
            _js = js;
        }
        public async Task<string?> Login(string username, string password)
        {
            var response = await _http.PostAsJsonAsync("/login", new { username, password });
            if (!response.IsSuccessStatusCode) return null;
            var result = await response.Content.ReadFromJsonAsync<LoginResult>();
            await _js.InvokeVoidAsync("localStorage.setItem", TokenKey, result?.token);
            return result?.token;
        }
        public async Task<string?> GetToken()
        {
            return await _js.InvokeAsync<string>("localStorage.getItem", TokenKey);
        }
        public async Task Logout()
        {
            await _js.InvokeVoidAsync("localStorage.removeItem", TokenKey);
        }
        private class LoginResult { public string? token { get; set; } }
    }
}

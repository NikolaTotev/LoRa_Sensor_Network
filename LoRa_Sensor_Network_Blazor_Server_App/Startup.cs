using LoRa_Sensor_Network_Blazor_Server_App.Data;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using LoRa_Sensor_Network_Blazor_Server_App.DatabaseLogic;
using LoRa_Sensor_Network_Blazor_Server_App.UtilityClasses;
using LoRa_Sensor_Network_Blazor_Server_App.Hubs;
using Microsoft.AspNetCore.SignalR;

namespace LoRa_Sensor_Network_Blazor_Server_App
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            //services.AddRazorPages();
            //services.AddServerSideBlazor();
            //services.AddSingleton<WeatherForecastService>();
            services.AddControllers();
            services.AddSingleton<IConfiguration>(Configuration);
            services.AddSingleton<UplinkDataAccess>();
            services.AddSignalR();
            services.AddCors(options =>
                options.AddPolicy("CorsPolicy",
                    builder =>
                        builder.AllowAnyMethod()
                        .AllowAnyHeader()
                        .WithOrigins("http://localhost:3000")
                        .AllowCredentials()));
        }


        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IHostApplicationLifetime hostApplicationLifetime)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();
            app.UseCors("CorsPolicy");

            app.UseEndpoints(endpoints =>
            {
                //endpoints.MapBlazorHub();
                //endpoints.MapFallbackToPage("/_Host");
                //endpoints.MapControllers();

                endpoints.MapHub<InitHub>("/initTry");
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller}/{action=Index}/{id?}");
            });

            hostApplicationLifetime.ApplicationStarted.Register(() =>
            {
                var serviceProvider = app.ApplicationServices;
                var chatHub = (IHubContext<InitHub>)serviceProvider.GetService(typeof(IHubContext<InitHub>));

                var timer = new System.Timers.Timer(1000);
                timer.Enabled = true;
                timer.Elapsed += delegate (object sender, System.Timers.ElapsedEventArgs e) {
                    chatHub.Clients.All.SendAsync("setTime", DateTime.Now.ToString("dddd d MMMM yyyy HH:mm:ss"));
                };
                timer.Start();
            });
        }
    }
}

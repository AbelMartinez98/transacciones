using Microsoft.EntityFrameworkCore;
using transacciones_api.Datos;
using transacciones_api.Repositories;
using transacciones_api.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddDbContext<TransaccionesDbContext>(opciones =>
    opciones.UseSqlServer("name=DefaultConnection"));
builder.Services.AddScoped<ITransaccionRepository, TransaccionRepository>();
builder.Services.AddScoped<TransaccionService>();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Escucha en distintas interfaces
app.Urls.Add("http://0.0.0.0:5208");

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

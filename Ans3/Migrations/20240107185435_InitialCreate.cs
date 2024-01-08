using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ans3.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "DataModels",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FullPowerMode = table.Column<bool>(type: "bit", nullable: true),
                    ActivePowerControl = table.Column<bool>(type: "bit", nullable: true),
                    FirmwareVersion = table.Column<int>(type: "int", nullable: true),
                    Temperature = table.Column<int>(type: "int", nullable: true),
                    Humidity = table.Column<int>(type: "int", nullable: true),
                    Version = table.Column<int>(type: "int", nullable: true),
                    MessageType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Occupancy = table.Column<bool>(type: "bit", nullable: true),
                    StateChanged = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DataModels", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PayloadDataModels",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DeviceId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DeviceType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DeviceName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    GroupId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DataType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DataId = table.Column<int>(type: "int", nullable: false),
                    Timestamp = table.Column<long>(type: "bigint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PayloadDataModels", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PayloadDataModels_DataModels_DataId",
                        column: x => x.DataId,
                        principalTable: "DataModels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_PayloadDataModels_DataId",
                table: "PayloadDataModels",
                column: "DataId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PayloadDataModels");

            migrationBuilder.DropTable(
                name: "DataModels");
        }
    }
}

using System.ComponentModel.DataAnnotations;

namespace Ans3.Models
{
    public class DeviceModel
    {
    }
    public class PayloadDataModel
    {
        [Key]
        public int Id { get; set; }

        public string DeviceId { get; set; }
        public string DeviceType { get; set; }
        public string DeviceName { get; set; }
        public string GroupId { get; set; }
        public string DataType { get; set; }

        // Navigation property
        public DataModel Data { get; set; }

        public long Timestamp { get; set; }
    }


    public class DataModel
    {
        [Key]
        public int Id { get; set; }

        public bool? FullPowerMode { get; set; }
        public bool? ActivePowerControl { get; set; }
        public int? FirmwareVersion { get; set; }
        public int? Temperature { get; set; }
        public int? Humidity { get; set; }

        public int? Version { get; set; }
        public string? MessageType { get; set; }
        public bool? Occupancy { get; set; }
        public int? StateChanged { get; set; }
    }

}

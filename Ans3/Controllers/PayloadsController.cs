using Ans3.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace Ans3.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class PayloadsController : ControllerBase
    {
        private readonly DBContext _dbContext;
        private readonly ILogger<PayloadsController> _logger;
        public PayloadsController(ILogger<PayloadsController> logger, DBContext dbContext)
        {
            _dbContext = dbContext;
            _logger = logger;
        }
        
        [HttpGet(Name = "GetAllPayloads")]
        public async Task<ActionResult<IEnumerable<PayloadDataModel>>> GetAllPayloads()
        {
            try
            {
                _logger.LogInformation("Getting all payloads.");

                var payloads = await _dbContext.PayloadDataModels
                    .Include(pdm => pdm.Data)
                    .ToListAsync();

                _logger.LogInformation($"Retrieved {payloads.Count} payloads.");

                return Ok(payloads);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An error occurred while getting all payloads.");
                return StatusCode(500, "Internal Server Error");
            }
        }
        
        [HttpGet("{id}", Name = "GetPayloadById")]
        public async Task<ActionResult<PayloadDataModel>> GetPayloadById(int id)
        {
            try
            {
                _logger.LogInformation($"Getting payload with ID {id}.");

                var payload = await _dbContext.PayloadDataModels
                    .Include(pdm => pdm.Data)
                    .FirstOrDefaultAsync(pdm => pdm.Id == id);

                if (payload == null)
                {
                    _logger.LogWarning($"Payload with ID {id} not found.");
                    return NotFound();
                }

                _logger.LogInformation($"Retrieved payload with ID {id}.");

                return Ok(payload);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"An error occurred while getting payload with ID {id}.");
                return StatusCode(500, "Internal Server Error");
            }
        }

        
        [HttpPost]
        public IActionResult ReceivePayload([FromBody] PayloadDataModel payloadData)
        {
            //dummy data
            //1 {
            //                    "deviceId": "ibm-878A66",
            //    "deviceType": "computer1.0.0",
            //    "deviceName": "VN1-1-3",
            //    "groupId": "847b3b2f1b05dc4",
            //    "dataType": "DATA",
            //    "data": {
            //                        "fullPowerMode": false,
            //    "activePowerControl": false,
            //    "firmwareVersion": 1,
            //    "temperature": 21,
            //    "humidity": 53
            //    },
            //    "timestamp": 1629369697
            //    }
            //                2 {
            //                    "deviceId": "ibm-00976A",
            //    "deviceType": "computer1.0.0",
            //    "deviceName": "VN1-1-4",
            //    "groupId": "49548881c4d2bea9",
            //    "dataType": "DATA",
            //    "data": {
            //                        "version": 3,
            //    "messageType": "periodic",
            //    "occupancy": false,
            //    "stateChanged": 0
            //    },
            //    "timestamp": 1629629040
            //}
            try
            {
                ValidatePayload(payloadData);

                // Convert PayloadDataModel to Payload entity (assuming you have a Payload entity)
                var payload = new PayloadDataModel
                {
                    DeviceId = payloadData.DeviceId,
                    DeviceType = payloadData.DeviceType,
                    DeviceName = payloadData.DeviceName,
                    GroupId = payloadData.GroupId,
                    DataType = payloadData.DataType,
                    Data = payloadData.Data,
                    Timestamp = payloadData.Timestamp
                };

                _dbContext.PayloadDataModels.Add(payload);
                _dbContext.SaveChanges();

                _logger.LogInformation("Payload received and stored successfully.");
                return Ok("Payload received and stored successfully.");
            }
            catch (ValidationException ex)
            {
                _logger.LogWarning(ex.Message);
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing payload.");
                return StatusCode(500, "Internal server error.");
            }
        }

        private void ValidatePayload(PayloadDataModel payloadData)
        {
            ValidateNotNull(payloadData, "PayloadData");
            ValidateRequiredString(payloadData.DeviceId, "DeviceId");
            ValidatePositiveNumber(payloadData.Timestamp, "Timestamp");

            if (payloadData.Data != null)
            {
                if (HasGroupOneData(payloadData.Data))
                {
                    ValidateGroupOneData(payloadData.Data);
                }
                else if (HasGroupTwoData(payloadData.Data))
                {
                    ValidateGroupTwoData(payloadData.Data);
                }
                else
                {
                    HandleNoValidData();
                }
            }
            else
            {
                HandleNoValidData();
            }
        }

        private bool HasGroupOneData(DataModel data)
        {
            return data.FullPowerMode != null ||
                   data.ActivePowerControl != null ||
                   data.FirmwareVersion != null ||
                   data.Temperature != null ||
                   data.Humidity != null;
        }

        private bool HasGroupTwoData(DataModel data)
        {
            return data.Version != null ||
                   !string.IsNullOrEmpty(data.MessageType) ||
                   data.Occupancy != null ||
                   data.StateChanged != null;
        }

        private void ValidateGroupOneData(DataModel data)
        {
            // Check for the presence of each field individually
            if (data.FullPowerMode != null)
            {
                ValidateNotNull(data.FullPowerMode, "FullPowerMode");
            }

            if (data.ActivePowerControl != null)
            {
                ValidateNotNull(data.ActivePowerControl, "ActivePowerControl");
            }

            if (data.FirmwareVersion != null)
            {
                ValidateNotNull(data.FirmwareVersion, "FirmwareVersion");
            }

            if (data.Temperature != null)
            {
                ValidateTemperature(data.Temperature);
            }

            if (data.Humidity != null)
            {
                ValidateHumidity(data.Humidity);
            }
        }

        private void ValidateGroupTwoData(DataModel data)
        {
            // Check for the presence of each field individually
            if (data.Version != null)
            {
                ValidateNotNull(data.Version, "Version");
            }

            if (!string.IsNullOrEmpty(data.MessageType))
            {
                ValidateRequiredString(data.MessageType, "MessageType");
            }

            if (data.Occupancy != null)
            {
                ValidateNotNull(data.Occupancy, "Occupancy");
            }

            if (data.StateChanged != null)
            {
                ValidateNotNull(data.StateChanged, "StateChanged");
            }
        }

        private void HandleNoValidData()
        {
            
            _logger.LogWarning("No valid data found in either Group One or Group Two. Inserting empty data field names.");

            
        }

        private void ValidateNotNull(object value, string fieldName)
        {
            if (value == null)
            {
                _logger.LogWarning($"{fieldName} is null.");
                throw new ValidationException($"{fieldName} is required.");
            }
        }

        private void ValidateRequiredString(string value, string fieldName)
        {
            if (string.IsNullOrEmpty(value))
            {
                _logger.LogWarning($"{fieldName} is null.");
                throw new ValidationException($"{fieldName} is required.");
            }
        }

        private void ValidatePositiveNumber(long value, string fieldName)
        {
            if (value <= 0)
            {
                _logger.LogWarning($"Invalid {fieldName} value. It should be a positive number.");
                throw new ValidationException($"Invalid {fieldName} value. It should be a positive number.");
            }
        }

        private void ValidateTemperature(int? temperature)
        {
            if (temperature == null || temperature < -40 || temperature > 85)
            {
                _logger.LogWarning($"Invalid temperature value. It should be between -40 and 85.");
                throw new ValidationException("Invalid temperature value. It should be between -40 and 85.");
            }
        }

        private void ValidateHumidity(int? humidity)
        {
            if (humidity == null || humidity < 0 || humidity > 100)
            {
                _logger.LogWarning($"Invalid humidity value. It should be between 0 and 100.");
                throw new ValidationException("Invalid humidity value. It should be between 0 and 100.");
            }
        }


    }
}

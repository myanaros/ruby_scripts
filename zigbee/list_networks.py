import asyncio
import serial.tools.list_ports
from zigpy_znp.zigpy_application import ZigpyApplication
from zigpy_znp.config import ZnpConfiguration

# List all available serial ports
ports = serial.tools.list_ports.comports()
print("Available serial ports:")
for port in ports:
    print(f"{port.device} - {port.description}")

# Try to find Sonoff ZBDongle-P (TI chip)
zigbee_port = None
for port in ports:
    if "Sonoff" in port.description or "Zigbee" in port.description:
        zigbee_port = port.device
        break

if not zigbee_port:
    print("Sonoff ZBDongle-P not found.")
    exit(1)

print(f"Found Sonoff ZBDongle-P at: {zigbee_port}")

async def main():
    print("Initializing Zigpy ZNP application...")
    config = ZnpConfiguration(
        port=zigbee_port,
        baudrate=115200,
        flow_control=False,
    )
    app = await ZigpyApplication.new(config)
    print("Connected to Zigbee dongle.")
    print("Network info:")
    print(f"PAN ID: {app.state.network_pan_id}")
    print(f"Extended PAN ID: {app.state.network_extended_pan_id}")
    print(f"Channel: {app.state.network_channel}")
    print(f"IEEE Address: {app.state.ieee}")
    print(f"Devices:")
    for device in app.devices.values():
        print(f"  - {device.ieee}: {device.nwk}")
    await app.close()

if __name__ == "__main__":
    asyncio.run(main())

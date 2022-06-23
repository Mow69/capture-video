import bluetooth

print("Looking for bluetooth connected devices ....")
nearby_devices = bluetooth.discover_devices(lookup_names=True)


for addr, name in nearby_devices:
    print("address :", addr)
    print("name :", name)
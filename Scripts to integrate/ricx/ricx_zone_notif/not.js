exports('LocationNotif', (text, location, duration) => {
	const string = CreateVarString(10, "LITERAL_STRING", location);
	const string2 = CreateVarString(10, "LITERAL_STRING", text);

	const struct1 = new DataView(new ArrayBuffer(48));
	struct1.setInt32(0, duration, true);
	// struct1.setBigInt64(8, BigInt(sound_dict), true); // Notification sound optional
	// struct1.setBigInt64(16, BigInt(sound), true);

	const struct2 = new DataView(new ArrayBuffer(24));
	struct2.setBigInt64(8, BigInt(string), true);
	struct2.setBigInt64(16, BigInt(string2), true);
	Citizen.invokeNative("0xD05590C1AB38F068", struct1, struct2, 1, 1);
});

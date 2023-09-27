object "Proxy" {
	// deployment code
	code {
		let size := datasize("runtime")
		datacopy(0, dataoffset("runtime"), size)
		return(0, size)
	}
	object "runtime" {
		// deployed code
		code {
			// check isAddressWhitelisted
			checkRole()
			calldatacopy(0, 32, sub(calldatasize(), 32))
			let result := create2(callvalue(), 0, sub(calldatasize(), 32), calldataload(0))
			if iszero(result) { revert(0, 0) }
			mstore(0, result)
			return(12, 20)

			function checkRole() {
				let ptr := mload(0x40)
				// store func sig "isAddressWhitelisted(address)" to next 32 bytes
				// 0x0...013f44d10
				mstore(ptr, 0x13f44d10)
				// store msg.sender to next 32 bytes
				// 0x0...013f44d100...0CALLER
				mstore(add(ptr, 32), caller())
				// update 0x40 slot with 0x0...013f44d100...0CALLER
				mstore(0x40, add(ptr, 64))
				// check is call successful to ConfigController address with slice from 28 bytes(cut zero at left) of 0x40
				// 0x13f44d100...0CALLER and save result to 0x40 with size of 32 bytes
				if iszero(staticcall(not(0), 0xD2002000000000000000000000000000000000D2, add(ptr, 28), 36, ptr, 32)) {
					revert(0,0)
				}
				// check is result false - revert
				if iszero(mload(ptr)) {
					revert(0,0)
				}
			}
		}
	}
}

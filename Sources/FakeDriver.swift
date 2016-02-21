class FakeDriver: SQLDriver {
	func connect(parameters: [String: String]) -> Bool {
		return false
	}

	func connect(connectionString: String) -> Bool {
		return false
	}

	func disconnect() { 
	}

	func status() -> SQLDriverStatus {
		return .Disconnected
	}

	func execute(query: String) -> Array<[String: Any]> {
		return Array<[String: Any]>()
	}
}
public class FakeDriver: SQLDriver {
	public func connect(parameters: [String: String]) -> Bool {
		return false
	}

	public func connect(connectionString: String) -> Bool {
		return false
	}

	public func disconnect() { 
	}

	public func status() -> SQLDriverStatus {
		return .Disconnected
	}

	public func execute(query: String) -> Array<[String: Any]> {
		return Array<[String: Any]>()
	}
}
public class UnsupportedDriver: SQLDriver {
	public class func initInstance() -> SQLDriver {
		return UnsupportedDriver()
	}

	public func connect(parameters: [String: String]) -> Bool {
		return false
	}

	public func connect(connectionString: String) -> Bool {
		return false
	}

	public func disconnect() { 
	}

	public var connected: Bool {
		return false
	}

	public func execute(query: String) -> Array<[String: Any]> {
		return Array<[String: Any]>()
	}

	public func execute(query: String, parameters: Any...) -> Array<[String: Any]> {
		return Array<[String: Any]>()	
	}
}
public enum SQLDriverStatus {
	case Connected
    case Disconnected
}

public protocol SQLDriver {
	func connect(parameters: [String: String]) -> Bool
	func connect(connectionString: String) -> Bool
	func disconnect()

	func status() -> SQLDriverStatus
	func execute(query: String) -> Array<[String: Any]>
}
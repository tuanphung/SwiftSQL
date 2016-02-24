public protocol SQLDriver {
	func connect(parameters: [String: String]) -> Bool
	func connect(connectionString: String) -> Bool
	func disconnect()

	var connected: Bool { get }
	func execute(query: String) -> Array<[String: Any]>
	func execute(query: String, parameters: Any...) -> Array<[String: Any]>
}
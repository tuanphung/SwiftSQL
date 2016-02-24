public protocol SQLModel {
	///The database table in which entities are stored.
	static var table: String { get }

	init(serialized: [String: String])
}
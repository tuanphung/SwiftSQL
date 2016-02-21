public enum SQLType {
	case Postgre
	case MySQL
	case SQLite
}

private func initSQLDriver(type: SQLType) -> SQLDriver {
	switch type {
		case .Postgre: return PostgreSQLDriver()
		default: 
			print("\(type) is not supported.")
			return FakeDriver()
	}
}

class SQL {
	class final func open(type: SQLType, parameters: [String: String]) -> SQLDriver {
		let driver = initSQLDriver(type)
		driver.connect(parameters)
		return driver
	}

	class final func open(type: SQLType, connectionString: String) -> SQLDriver {
		let driver = initSQLDriver(type)
		driver.connect(connectionString)
		return driver
	}
}
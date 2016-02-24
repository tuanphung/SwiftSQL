public enum SQLType {
	case Postgre
	case MySQL
	case SQLite
}

public class SQL {
	private class func produceSQLDriverWithType(type: SQLType) -> SQLDriver {
		switch type {
			case .Postgre: return PostgreSQLDriver()
			default: 
				print("\(type) is not supported.")
				return UnsupportedDriver()
		}
	}

	public class func open(type: SQLType, parameters: [String: String]) -> SQLDriver {
		let driver = produceSQLDriverWithType(type)
		driver.connect(parameters)
		return driver
	}

	public class func open(type: SQLType, connectionString: String) -> SQLDriver {
		let driver = produceSQLDriverWithType(type)
		driver.connect(connectionString)
		return driver
	}
}
import libpq

class PostgreSQLDriver: SQLDriver {
	var connectionPointer: COpaquePointer!

	func connect(parameters: [String: String]) -> Bool {
		let pghost = parameters["pghost"] ?? "localhost"
		let pgport = parameters["pgport"] ?? "5432"
		let pgoptions = parameters["pgoptions"] ?? ""
		let pgtty = parameters["pgtty"] ?? ""
		let dbName = parameters["dbName"] ?? ""
		let login = parameters["login"] ?? ""
		let pwd = parameters["pwd"] ?? ""

		connectionPointer = PQsetdbLogin(pghost,
	            pgport,
	            pgoptions,
	            pgtty,
	            dbName,
	            login,
	            pwd)

		guard PQstatus(connectionPointer) == CONNECTION_OK else {
		    print(String.fromCString(PQerrorMessage(connectionPointer)))
		    return false
		}

		return true
	}

	func connect(connectionString: String) -> Bool {
		connectionPointer = PQconnectdb(connectionString)

		guard PQstatus(connectionPointer) == CONNECTION_OK else {
		    print(String.fromCString(PQerrorMessage(connectionPointer)))
		    return false
		}

		return true
	}

	func disconnect() {
		PQfinish(connectionPointer)
	}

	func status() -> SQLDriverStatus {
		guard PQstatus(connectionPointer) == CONNECTION_OK else {
		    return .Disconnected
		}

		return .Connected
	}

	func execute(query: String) -> Array<[String: Any]> {
		let resultPointer = PQexecParams(connectionPointer,
                                         query,
                                         0,
                                         nil,
                                         nil,
                                         nil,
                                         nil,
                                         0)

        let status = PQresultStatus(resultPointer)

        switch status {
        case PGRES_COMMAND_OK, PGRES_TUPLES_OK:
        	return parseResultPointer(resultPointer)
        default:
            print(String.fromCString(PQresultErrorMessage(resultPointer)))
			return Array<[String: Any]>()
        }
	}

	private func parseResultPointer(resultPointer: COpaquePointer) -> Array<[String: Any]> {
		let numberOfFields = PQnfields(resultPointer)
		let numberOfRecords = PQntuples(resultPointer)

		// Retrieve column name from sql query
		var fieldNames = [String]()
		for column in 0..<numberOfFields {
			if let name = String.fromCString(PQfname(resultPointer, column)) {
				fieldNames.append(name)
			}
			else {
				fieldNames.append("Unnamed")
			}
		}

		// Parse data rows
		var records = Array<[String: Any]>()
		for row in 0..<numberOfRecords {
			var record = [String: Any]()

			for column in 0..<numberOfFields {
				if PQgetisnull(resultPointer, row, column) == 0 {
					let name = fieldNames[Int(column)]
					let value = String.fromCString(PQgetvalue(resultPointer, row, column))
					record[name] = value
				}
			}

			records.append(record)
		}

		return records
	}
}
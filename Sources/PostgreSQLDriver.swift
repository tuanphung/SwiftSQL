import libpq

public class PostgreSQLDriver: SQLDriver {
	private var connectionPointer: COpaquePointer!

	var status: Status {
		return Status(status: PQstatus(connectionPointer))
	}

	public enum Status {
        case Bad
        case Started
        case Made
        case AwatingResponse
        case AuthOK
        case SettingEnvironment
        case SSLStartup
        case OK
        case Unknown
        case Needed
        
        public init(status: ConnStatusType) {
            switch status {
            case CONNECTION_NEEDED:
                self = .Needed
            case CONNECTION_OK:
                self = .OK
            case CONNECTION_STARTED:
                self = .Started
            case CONNECTION_MADE:
                self = .Made
            case CONNECTION_AWAITING_RESPONSE:
                self = .AwatingResponse
            case CONNECTION_AUTH_OK:
                self = .AuthOK
            case CONNECTION_SSL_STARTUP:
                self = .SSLStartup
            case CONNECTION_SETENV:
                self = .SettingEnvironment
            case CONNECTION_BAD:
                self = .Bad
            default:
                self = .Unknown
            }
        }
    }

	public func connect(parameters: [String: String]) -> Bool {
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

	public func connect(connectionString: String) -> Bool {
		connectionPointer = PQconnectdb(connectionString)

		guard PQstatus(connectionPointer) == CONNECTION_OK else {
		    print(String.fromCString(PQerrorMessage(connectionPointer)))
		    return false
		}

		return true
	}

	public func disconnect() {
		PQfinish(connectionPointer)

		connectionPointer = nil
	}

	public var connected: Bool {
		return (status == .OK || status == .Made)
	}

	public func execute(query: String) -> Array<[String: Any]> {
		let resultPointer = PQexec(connectionPointer, query)

        let status = PQresultStatus(resultPointer)

        switch status {
        case PGRES_COMMAND_OK, PGRES_TUPLES_OK:
        	return readResultPointer(resultPointer)
        default:
            print(String.fromCString(PQresultErrorMessage(resultPointer)))
			return Array<[String: Any]>()
        }
	}

	public func execute(query: String, parameters: Any...) -> Array<[String: Any]> {
		let values = UnsafeMutablePointer<UnsafePointer<Int8>>.alloc(parameters.count)

        defer {
            values.destroy()
            values.dealloc(parameters.count)
        }

        var temps = [Array<UInt8>]()
        for (i, v) in parameters.enumerate() {
        	let value = Array<UInt8>("\(v)".utf8) + [0]
            values[i] = UnsafePointer<Int8>(value)

            // Keep reference to value.
            temps.append(value)
        }

        let resultPointer = PQexecParams(connectionPointer,
                                         query,
                                         Int32(parameters.count),
                                         nil,
                                         values,
                                         nil,
                                         nil,
                                         0)

        let status = PQresultStatus(resultPointer)

        switch status {
        case PGRES_COMMAND_OK, PGRES_TUPLES_OK:
        	return readResultPointer(resultPointer)
        default:
            print(String.fromCString(PQresultErrorMessage(resultPointer)))
			return Array<[String: Any]>()
        }
	}

	private func readResultPointer(resultPointer: COpaquePointer) -> Array<[String: Any]> {
		let numberOfFields = PQnfields(resultPointer)
		let numberOfRecords = PQntuples(resultPointer)

		// Retrieve column name from sql query
		var fieldNames = [String]()
		for column in 0..<numberOfFields {
			if let name = String.fromCString(PQfname(resultPointer, column)) {
				fieldNames.append(name)
			}
			else {
				fieldNames.append("Unnamed\(column)")
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
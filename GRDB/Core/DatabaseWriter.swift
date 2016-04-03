/// The protocol for all types that can update a database.
///
/// It is adopted by DatabaseQueue, DatabasePool, and Database.
///
///     let person = Person(...)
///     try person.insert(dbQueue)
///     try person.insert(dbPool)
///     try dbQueue.inDatabase { db in
///         try person.insert(db)
///     }
///
/// The protocol comes with isolation guarantees that describe the behavior of
/// adopting types in a multithreaded application.
///
/// Types that adopt the protocol can provide stronger guarantees in practice.
/// For example, DatabaseQueue provides a stronger isolation level
/// than DatabasePool.
///
/// **Warning**: Isolation guarantees stand as long as there is no external
/// connection to the database. Should you have to cope with external
/// connections, protect yourself with transactions, and be ready to setup a
/// [busy handler](https://www.sqlite.org/c3ref/busy_handler.html).
public protocol DatabaseWriter : DatabaseReader {
    
    // MARK: - Writing in Database
    
    /// Synchronously executes a block that takes a database connection, and
    /// returns its result.
    ///
    /// The *block* argument is completely isolated. Eventual concurrent
    /// database updates are postponed until the block has executed.
    func write<T>(block: (db: Database) throws -> T) rethrows -> T
    
    
    // MARK: - Reading from Database
    
    /// Synchronously or asynchronously executes a read-only block that takes a
    /// database connection.
    ///
    /// This method must be called from a writing dispatch queue.
    ///
    /// The *block* argument is guaranteed to see the database in the state it
    /// has at the moment this method is called. Eventual concurrent
    /// database updates are *not visible* inside the block.
    ///
    ///     try writer.write { db in
    ///         try db.execute("DELETE FROM persons")
    ///         writer.readFromWrite { db in
    ///             // Guaranteed to be zero
    ///             Int.fetchOne(db, "SELECT COUNT(*) FROM persons")!
    ///         }
    ///         try db.execute("INSERT INTO persons ...")
    ///     }
    ///
    /// DatabasePool.readFromWrite runs *block* asynchronously in a concurrent
    /// reader dispatch queue, and release the writing dispatch queue early,
    /// before the block has finished. In the example above, the insertion runs
    /// concurrently with the select (and yet the select is guaranteed not to
    /// see the insertion).
    ///
    /// DatabaseQueue.readFromWrite simply runs *block* synchronously, and
    /// returns when the block has completed. In the example above, the
    /// insertion is run after the select.
    func readFromWrite(block: (db: Database) -> Void)
    
    
    // MARK: - Encryption
    
    /// TODO
    func setKey(passphrase: String) throws
    
    /// TODO
    func reKey(passphrase: String) throws
}

extension DatabaseWriter {
    
    // MARK: - Writing in Database
    
    /// Executes one or several SQL statements, separated by semi-colons.
    ///
    ///     try writer.execute(
    ///         "INSERT INTO persons (name) VALUES (:name)",
    ///         arguments: ["name": "Arthur"])
    ///
    ///     try writer.execute(
    ///         "INSERT INTO persons (name) VALUES (?);" +
    ///         "INSERT INTO persons (name) VALUES (?);" +
    ///         "INSERT INTO persons (name) VALUES (?);",
    ///         arguments; ['Arthur', 'Barbara', 'Craig'])
    ///
    /// This method may throw a DatabaseError.
    ///
    /// See documentation of the write() method for information about the
    /// isolation from concurrent database updates.
    ///
    /// - parameters:
    ///     - sql: An SQL query.
    ///     - arguments: Optional statement arguments.
    /// - returns: A DatabaseChanges.
    /// - throws: A DatabaseError whenever an SQLite error occurs.
    public func execute(sql: String, arguments: StatementArguments? = nil) throws -> DatabaseChanges {
        return try write { db in
            try db.execute(sql, arguments: arguments)
        }
    }
    
    
    // MARK: - Transaction Observers
    
    /// Add a transaction observer, so that it gets notified of all
    /// database changes.
    ///
    /// The transaction observer is weakly referenced: it is not retained, and
    /// stops getting notifications after it is deallocated.
    public func addTransactionObserver(transactionObserver: TransactionObserverType) {
        write { db in
            db.addTransactionObserver(transactionObserver)
        }
    }
    
    /// Remove a transaction observer.
    public func removeTransactionObserver(transactionObserver: TransactionObserverType) {
        write { db in
            db.removeTransactionObserver(transactionObserver)
        }
    }
}

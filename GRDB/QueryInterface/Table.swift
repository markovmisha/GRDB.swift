/// A table that can be used with the GRDB query interface.
public struct Table<RowDecoder> {
    /// The table name
    public var tableName: String
    
    /// Create a `Table`
    public init(_ tableName: String) {
        self.tableName = tableName
    }
}

extension Table {
    var relationForAll: SQLRelation {
        .all(fromTable: tableName)
    }
    
    /// Creates a request for all rows of the table.
    ///
    /// You can, for example, fetch from this request:
    ///
    ///     let table = Table<Row>("player")
    ///     let rows: [Row] = try table.all().fetchAll(db)
    public func all() -> QueryInterfaceRequest<RowDecoder> {
        QueryInterfaceRequest(relation: relationForAll)
    }
}

// MARK: - Associations to TableRecord

extension Table {
    /// Creates a "Belongs To" association between Self and the destination
    /// type, based on a database foreign key.
    ///
    /// For more information, see `TableRecord.belongsTo(_:key:using:)`.
    ///
    /// - parameters:
    ///     - destination: The record type at the other side of the association.
    ///     - key: An eventual decoding key for the association. By default, it
    ///       is `destination.databaseTableName`.
    ///     - foreignKey: An eventual foreign key. You need to provide an
    ///       explicit foreign key when GRDB can't infer one from the database
    ///       schema. This happens when the schema does not define any foreign
    ///       key to the destination table, or when the schema defines several
    ///       foreign keys to the destination table.
    public func belongsTo<Destination>(
        _ destination: Destination.Type,
        key: String? = nil,
        using foreignKey: ForeignKey? = nil)
    -> BelongsToAssociation<RowDecoder, Destination>
    where Destination: TableRecord
    {
        BelongsToAssociation(
            to: Destination.relationForAll,
            key: key,
            using: foreignKey)
    }
    
    /// Creates a "Has many" association between Self and the destination type,
    /// based on a database foreign key.
    ///
    /// For more information, see `TableRecord.hasMany(_:key:using:)`.
    ///
    /// - parameters:
    ///     - destination: The record type at the other side of the association.
    ///     - key: An eventual decoding key for the association. By default, it
    ///       is `destination.databaseTableName`.
    ///     - foreignKey: An eventual foreign key. You need to provide an
    ///       explicit foreign key when GRDB can't infer one from the database
    ///       schema. This happens when the schema does not define any foreign
    ///       key from the destination table, or when the schema defines several
    ///       foreign keys from the destination table.
    public func hasMany<Destination>(
        _ destination: Destination.Type,
        key: String? = nil,
        using foreignKey: ForeignKey? = nil)
    -> HasManyAssociation<RowDecoder, Destination>
    where Destination: TableRecord
    {
        HasManyAssociation(
            to: Destination.relationForAll,
            key: key,
            using: foreignKey)
    }
    
    /// Creates a "Has one" association between Self and the destination type,
    /// based on a database foreign key.
    ///
    /// For more information, see `TableRecord.hasOne(_:key:using:)`.
    ///
    /// - parameters:
    ///     - destination: The record type at the other side of the association.
    ///     - key: An eventual decoding key for the association. By default, it
    ///       is `destination.databaseTableName`.
    ///     - foreignKey: An eventual foreign key. You need to provide an
    ///       explicit foreign key when GRDB can't infer one from the database
    ///       schema. This happens when the schema does not define any foreign
    ///       key from the destination table, or when the schema defines several
    ///       foreign keys from the destination table.
    public func hasOne<Destination>(
        _ destination: Destination.Type,
        key: String? = nil,
        using foreignKey: ForeignKey? = nil)
    -> HasOneAssociation<Self, Destination>
    where Destination: TableRecord
    {
        HasOneAssociation(
            to: Destination.relationForAll,
            key: key,
            using: foreignKey)
    }
}

// MARK: - Associations to Table

extension Table {
    /// Creates a "Belongs To" association between Self and the destination
    /// table, based on a database foreign key.
    ///
    /// For more information, see `TableRecord.belongsTo(_:key:using:)`.
    ///
    /// - parameters:
    ///     - destination: The table at the other side of the association.
    ///     - key: An eventual decoding key for the association. By default, it
    ///       is `destination.tableName`.
    ///     - foreignKey: An eventual foreign key. You need to provide an
    ///       explicit foreign key when GRDB can't infer one from the database
    ///       schema. This happens when the schema does not define any foreign
    ///       key to the destination table, or when the schema defines several
    ///       foreign keys to the destination table.
    public func belongsTo<Destination>(
        _ destination: Table<Destination>,
        key: String? = nil,
        using foreignKey: ForeignKey? = nil)
    -> BelongsToAssociation<RowDecoder, Destination>
    {
        BelongsToAssociation(
            to: destination.relationForAll,
            key: key,
            using: foreignKey)
    }
    
    /// Creates a "Has many" association between Self and the destination table,
    /// based on a database foreign key.
    ///
    /// For more information, see `TableRecord.hasMany(_:key:using:)`.
    ///
    /// - parameters:
    ///     - destination: The table at the other side of the association.
    ///     - key: An eventual decoding key for the association. By default, it
    ///       is `destination.tableName`.
    ///     - foreignKey: An eventual foreign key. You need to provide an
    ///       explicit foreign key when GRDB can't infer one from the database
    ///       schema. This happens when the schema does not define any foreign
    ///       key from the destination table, or when the schema defines several
    ///       foreign keys from the destination table.
    public func hasMany<Destination>(
        _ destination: Table<Destination>,
        key: String? = nil,
        using foreignKey: ForeignKey? = nil)
    -> HasManyAssociation<RowDecoder, Destination>
    {
        HasManyAssociation(
            to: destination.relationForAll,
            key: key,
            using: foreignKey)
    }
    
    /// Creates a "Has one" association between Self and the destination table,
    /// based on a database foreign key.
    ///
    /// For more information, see `TableRecord.hasOne(_:key:using:)`.
    ///
    /// - parameters:
    ///     - destination: The table at the other side of the association.
    ///     - key: An eventual decoding key for the association. By default, it
    ///       is `destination.databaseTableName`.
    ///     - foreignKey: An eventual foreign key. You need to provide an
    ///       explicit foreign key when GRDB can't infer one from the database
    ///       schema. This happens when the schema does not define any foreign
    ///       key from the destination table, or when the schema defines several
    ///       foreign keys from the destination table.
    public func hasOne<Destination>(
        _ destination: Table<Destination>,
        key: String? = nil,
        using foreignKey: ForeignKey? = nil)
    -> HasOneAssociation<RowDecoder, Destination>
    {
        HasOneAssociation(
            to: destination.relationForAll,
            key: key,
            using: foreignKey)
    }
}

// MARK: - Associations to CommonTableExpression

extension Table {
    /// Creates an association to a common table expression that you can join
    /// or include in another request.
    ///
    /// For more information, see `TableRecord.association(to:on:)`.
    ///
    /// - parameter cte: A common table expression.
    /// - parameter condition: A function that returns the joining clause.
    /// - parameter left: A `TableAlias` for the left table.
    /// - parameter right: A `TableAlias` for the right table.
    /// - returns: An association to the common table expression.
    public func association<Destination>(
        to cte: CommonTableExpression<Destination>,
        on condition: @escaping (_ left: TableAlias, _ right: TableAlias) -> SQLExpressible)
    -> JoinAssociation<RowDecoder, Destination>
    {
        JoinAssociation(to: cte.relationForAll, condition: .expression(condition))
    }
    
    /// Creates an association to a common table expression that you can join
    /// or include in another request.
    ///
    /// The key of the returned association is the table name of the common
    /// table expression.
    ///
    /// - parameter cte: A common table expression.
    /// - returns: An association to the common table expression.
    public func association<Destination>(
        to cte: CommonTableExpression<Destination>)
    -> JoinAssociation<RowDecoder, Destination>
    {
        JoinAssociation(to: cte.relationForAll, condition: .none)
    }
}

// MARK: - "Through" Associations

extension Table {
    /// Creates a "Has Many Through" association between Self and the
    /// destination type.
    ///
    /// For more information, see `TableRecord.hasMany(_:through:using:key:)`.
    ///
    /// - parameters:
    ///     - destination: The record type at the other side of the association.
    ///     - pivot: An association from Self to the intermediate type.
    ///     - target: A target association from the intermediate type to the
    ///       destination type.
    ///     - key: An eventual decoding key for the association. By default, it
    ///       is the same key as the target.
    public func hasMany<Pivot, Target>(
        _ destination: Target.RowDecoder.Type,
        through pivot: Pivot,
        using target: Target,
        key: String? = nil)
    -> HasManyThroughAssociation<RowDecoder, Target.RowDecoder>
    where Pivot: Association,
          Target: Association,
          Pivot.OriginRowDecoder == Self,
          Pivot.RowDecoder == Target.OriginRowDecoder
    {
        let association = HasManyThroughAssociation<RowDecoder, Target.RowDecoder>(
            sqlAssociation: target._sqlAssociation.through(pivot._sqlAssociation))
        
        if let key = key {
            return association.forKey(key)
        } else {
            return association
        }
    }
    
    /// Creates a "Has One Through" association between Self and the
    /// destination type.
    ///
    /// For more information, see `TableRecord.hasOne(_:through:using:key:)`.
    ///
    /// - parameters:
    ///     - destination: The record type at the other side of the association.
    ///     - pivot: An association from Self to the intermediate type.
    ///     - target: A target association from the intermediate type to the
    ///       destination type.
    ///     - key: An eventual decoding key for the association. By default, it
    ///       is the same key as the target.
    public func hasOne<Pivot, Target>(
        _ destination: Target.RowDecoder.Type,
        through pivot: Pivot,
        using target: Target,
        key: String? = nil)
    -> HasOneThroughAssociation<RowDecoder, Target.RowDecoder>
    where Pivot: AssociationToOne,
          Target: AssociationToOne,
          Pivot.OriginRowDecoder == Self,
          Pivot.RowDecoder == Target.OriginRowDecoder
    {
        let association = HasOneThroughAssociation<RowDecoder, Target.RowDecoder>(
            sqlAssociation: target._sqlAssociation.through(pivot._sqlAssociation))
        
        if let key = key {
            return association.forKey(key)
        } else {
            return association
        }
    }
}

// MARK: - Joining Methods

extension Table {
    /// Creates a request that prefetches an association.
    public func including<A: AssociationToMany>(all association: A)
    -> QueryInterfaceRequest<RowDecoder>
    where A.OriginRowDecoder == RowDecoder
    {
        all().including(all: association)
    }
    
    /// Creates a request that includes an association. The columns of the
    /// associated record are selected. The returned association does not
    /// require that the associated database table contains a matching row.
    public func including<A: Association>(optional association: A)
    -> QueryInterfaceRequest<RowDecoder>
    where A.OriginRowDecoder == RowDecoder
    {
        all().including(optional: association)
    }
    
    /// Creates a request that includes an association. The columns of the
    /// associated record are selected. The returned association requires
    /// that the associated database table contains a matching row.
    public func including<A: Association>(required association: A)
    -> QueryInterfaceRequest<RowDecoder>
    where A.OriginRowDecoder == RowDecoder
    {
        all().including(required: association)
    }
    
    /// Creates a request that includes an association. The columns of the
    /// associated record are not selected. The returned association does not
    /// require that the associated database table contains a matching row.
    public func joining<A: Association>(optional association: A)
    -> QueryInterfaceRequest<RowDecoder>
    where A.OriginRowDecoder == RowDecoder
    {
        all().joining(optional: association)
    }
    
    /// Creates a request that includes an association. The columns of the
    /// associated record are not selected. The returned association requires
    /// that the associated database table contains a matching row.
    public func joining<A: Association>(required association: A)
    -> QueryInterfaceRequest<RowDecoder>
    where A.OriginRowDecoder == RowDecoder
    {
        all().joining(required: association)
    }
}

// MARK: - Aggregates

extension Table {
    /// Creates a request with *aggregates* appended to the selection.
    ///
    ///     // SELECT player.*, COUNT(DISTINCT book.id) AS bookCount
    ///     // FROM player LEFT JOIN book ...
    ///     var request = Player.annotated(with: Player.books.count)
    public func annotated(with aggregates: AssociationAggregate<RowDecoder>...) -> QueryInterfaceRequest<RowDecoder> {
        all().annotated(with: aggregates)
    }
    
    /// Creates a request with *aggregates* appended to the selection.
    ///
    ///     // SELECT player.*, COUNT(DISTINCT book.id) AS bookCount
    ///     // FROM player LEFT JOIN book ...
    ///     var request = Player.annotated(with: [Player.books.count])
    public func annotated(with aggregates: [AssociationAggregate<RowDecoder>]) -> QueryInterfaceRequest<RowDecoder> {
        all().annotated(with: aggregates)
    }
    
    /// Creates a request with the provided aggregate *predicate*.
    ///
    ///     // SELECT player.*
    ///     // FROM player LEFT JOIN book ...
    ///     // HAVING COUNT(DISTINCT book.id) = 0
    ///     var request = Player.all()
    ///     request = request.having(Player.books.isEmpty)
    ///
    /// The selection defaults to all columns. This default can be changed for
    /// all requests by the `TableRecord.databaseSelection` property, or
    /// for individual requests with the `TableRecord.select` method.
    public func having(_ predicate: AssociationAggregate<RowDecoder>) -> QueryInterfaceRequest<RowDecoder> {
        all().having(predicate)
    }
}

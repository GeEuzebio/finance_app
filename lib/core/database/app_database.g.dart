// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<AccountType>($AccountsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<AccountOwner, int> owner =
      GeneratedColumn<int>('owner', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<AccountOwner>($AccountsTable.$converterowner);
  static const VerificationMeta _initialBalanceCentsMeta =
      const VerificationMeta('initialBalanceCents');
  @override
  late final GeneratedColumn<int> initialBalanceCents = GeneratedColumn<int>(
      'initial_balance_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _initialBalanceDateMeta =
      const VerificationMeta('initialBalanceDate');
  @override
  late final GeneratedColumn<DateTime> initialBalanceDate =
      GeneratedColumn<DateTime>('initial_balance_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _archivedMeta =
      const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
      'archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        owner,
        initialBalanceCents,
        initialBalanceDate,
        archived,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('initial_balance_cents')) {
      context.handle(
          _initialBalanceCentsMeta,
          initialBalanceCents.isAcceptableOrUnknown(
              data['initial_balance_cents']!, _initialBalanceCentsMeta));
    } else if (isInserting) {
      context.missing(_initialBalanceCentsMeta);
    }
    if (data.containsKey('initial_balance_date')) {
      context.handle(
          _initialBalanceDateMeta,
          initialBalanceDate.isAcceptableOrUnknown(
              data['initial_balance_date']!, _initialBalanceDateMeta));
    } else if (isInserting) {
      context.missing(_initialBalanceDateMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta,
          archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: $AccountsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      owner: $AccountsTable.$converterowner.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner'])!),
      initialBalanceCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}initial_balance_cents'])!,
      initialBalanceDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}initial_balance_date'])!,
      archived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, int, int> $convertertype =
      const EnumIndexConverter<AccountType>(AccountType.values);
  static JsonTypeConverter2<AccountOwner, int, int> $converterowner =
      const EnumIndexConverter<AccountOwner>(AccountOwner.values);
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String name;
  final AccountType type;
  final AccountOwner owner;
  final int initialBalanceCents;
  final DateTime initialBalanceDate;
  final bool archived;
  final DateTime createdAt;
  const Account(
      {required this.id,
      required this.name,
      required this.type,
      required this.owner,
      required this.initialBalanceCents,
      required this.initialBalanceDate,
      required this.archived,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>($AccountsTable.$convertertype.toSql(type));
    }
    {
      map['owner'] = Variable<int>($AccountsTable.$converterowner.toSql(owner));
    }
    map['initial_balance_cents'] = Variable<int>(initialBalanceCents);
    map['initial_balance_date'] = Variable<DateTime>(initialBalanceDate);
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      owner: Value(owner),
      initialBalanceCents: Value(initialBalanceCents),
      initialBalanceDate: Value(initialBalanceDate),
      archived: Value(archived),
      createdAt: Value(createdAt),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $AccountsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      owner: $AccountsTable.$converterowner
          .fromJson(serializer.fromJson<int>(json['owner'])),
      initialBalanceCents:
          serializer.fromJson<int>(json['initialBalanceCents']),
      initialBalanceDate:
          serializer.fromJson<DateTime>(json['initialBalanceDate']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type':
          serializer.toJson<int>($AccountsTable.$convertertype.toJson(type)),
      'owner':
          serializer.toJson<int>($AccountsTable.$converterowner.toJson(owner)),
      'initialBalanceCents': serializer.toJson<int>(initialBalanceCents),
      'initialBalanceDate': serializer.toJson<DateTime>(initialBalanceDate),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Account copyWith(
          {String? id,
          String? name,
          AccountType? type,
          AccountOwner? owner,
          int? initialBalanceCents,
          DateTime? initialBalanceDate,
          bool? archived,
          DateTime? createdAt}) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        owner: owner ?? this.owner,
        initialBalanceCents: initialBalanceCents ?? this.initialBalanceCents,
        initialBalanceDate: initialBalanceDate ?? this.initialBalanceDate,
        archived: archived ?? this.archived,
        createdAt: createdAt ?? this.createdAt,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      owner: data.owner.present ? data.owner.value : this.owner,
      initialBalanceCents: data.initialBalanceCents.present
          ? data.initialBalanceCents.value
          : this.initialBalanceCents,
      initialBalanceDate: data.initialBalanceDate.present
          ? data.initialBalanceDate.value
          : this.initialBalanceDate,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('owner: $owner, ')
          ..write('initialBalanceCents: $initialBalanceCents, ')
          ..write('initialBalanceDate: $initialBalanceDate, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, owner, initialBalanceCents,
      initialBalanceDate, archived, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.owner == this.owner &&
          other.initialBalanceCents == this.initialBalanceCents &&
          other.initialBalanceDate == this.initialBalanceDate &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<AccountOwner> owner;
  final Value<int> initialBalanceCents;
  final Value<DateTime> initialBalanceDate;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.owner = const Value.absent(),
    this.initialBalanceCents = const Value.absent(),
    this.initialBalanceDate = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String name,
    required AccountType type,
    required AccountOwner owner,
    required int initialBalanceCents,
    required DateTime initialBalanceDate,
    this.archived = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        owner = Value(owner),
        initialBalanceCents = Value(initialBalanceCents),
        initialBalanceDate = Value(initialBalanceDate),
        createdAt = Value(createdAt);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<int>? owner,
    Expression<int>? initialBalanceCents,
    Expression<DateTime>? initialBalanceDate,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (owner != null) 'owner': owner,
      if (initialBalanceCents != null)
        'initial_balance_cents': initialBalanceCents,
      if (initialBalanceDate != null)
        'initial_balance_date': initialBalanceDate,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<AccountType>? type,
      Value<AccountOwner>? owner,
      Value<int>? initialBalanceCents,
      Value<DateTime>? initialBalanceDate,
      Value<bool>? archived,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      owner: owner ?? this.owner,
      initialBalanceCents: initialBalanceCents ?? this.initialBalanceCents,
      initialBalanceDate: initialBalanceDate ?? this.initialBalanceDate,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($AccountsTable.$convertertype.toSql(type.value));
    }
    if (owner.present) {
      map['owner'] =
          Variable<int>($AccountsTable.$converterowner.toSql(owner.value));
    }
    if (initialBalanceCents.present) {
      map['initial_balance_cents'] = Variable<int>(initialBalanceCents.value);
    }
    if (initialBalanceDate.present) {
      map['initial_balance_date'] =
          Variable<DateTime>(initialBalanceDate.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('owner: $owner, ')
          ..write('initialBalanceCents: $initialBalanceCents, ')
          ..write('initialBalanceDate: $initialBalanceDate, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurrenceRulesTable extends RecurrenceRules
    with TableInfo<$RecurrenceRulesTable, RecurrenceRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrenceRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<RecurrenceFrequency, int>
      frequency = GeneratedColumn<int>('frequency', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<RecurrenceFrequency>(
              $RecurrenceRulesTable.$converterfrequency);
  static const VerificationMeta _intervalMeta =
      const VerificationMeta('interval');
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
      'interval', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _occurrenceCountMeta =
      const VerificationMeta('occurrenceCount');
  @override
  late final GeneratedColumn<int> occurrenceCount = GeneratedColumn<int>(
      'occurrence_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        description,
        amountCents,
        frequency,
        interval,
        startDate,
        endDate,
        occurrenceCount,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrence_rules';
  @override
  VerificationContext validateIntegrity(Insertable<RecurrenceRule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('interval')) {
      context.handle(_intervalMeta,
          interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta));
    } else if (isInserting) {
      context.missing(_intervalMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('occurrence_count')) {
      context.handle(
          _occurrenceCountMeta,
          occurrenceCount.isAcceptableOrUnknown(
              data['occurrence_count']!, _occurrenceCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurrenceRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurrenceRule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      frequency: $RecurrenceRulesTable.$converterfrequency.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}frequency'])!),
      interval: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      occurrenceCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}occurrence_count']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RecurrenceRulesTable createAlias(String alias) {
    return $RecurrenceRulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RecurrenceFrequency, int, int> $converterfrequency =
      const EnumIndexConverter<RecurrenceFrequency>(RecurrenceFrequency.values);
}

class RecurrenceRule extends DataClass implements Insertable<RecurrenceRule> {
  final String id;
  final String accountId;
  final String description;
  final int amountCents;
  final RecurrenceFrequency frequency;
  final int interval;
  final DateTime startDate;
  final DateTime? endDate;
  final int? occurrenceCount;
  final DateTime createdAt;
  const RecurrenceRule(
      {required this.id,
      required this.accountId,
      required this.description,
      required this.amountCents,
      required this.frequency,
      required this.interval,
      required this.startDate,
      this.endDate,
      this.occurrenceCount,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['description'] = Variable<String>(description);
    map['amount_cents'] = Variable<int>(amountCents);
    {
      map['frequency'] = Variable<int>(
          $RecurrenceRulesTable.$converterfrequency.toSql(frequency));
    }
    map['interval'] = Variable<int>(interval);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || occurrenceCount != null) {
      map['occurrence_count'] = Variable<int>(occurrenceCount);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecurrenceRulesCompanion toCompanion(bool nullToAbsent) {
    return RecurrenceRulesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      description: Value(description),
      amountCents: Value(amountCents),
      frequency: Value(frequency),
      interval: Value(interval),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      occurrenceCount: occurrenceCount == null && nullToAbsent
          ? const Value.absent()
          : Value(occurrenceCount),
      createdAt: Value(createdAt),
    );
  }

  factory RecurrenceRule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurrenceRule(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      description: serializer.fromJson<String>(json['description']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      frequency: $RecurrenceRulesTable.$converterfrequency
          .fromJson(serializer.fromJson<int>(json['frequency'])),
      interval: serializer.fromJson<int>(json['interval']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      occurrenceCount: serializer.fromJson<int?>(json['occurrenceCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'description': serializer.toJson<String>(description),
      'amountCents': serializer.toJson<int>(amountCents),
      'frequency': serializer.toJson<int>(
          $RecurrenceRulesTable.$converterfrequency.toJson(frequency)),
      'interval': serializer.toJson<int>(interval),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'occurrenceCount': serializer.toJson<int?>(occurrenceCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecurrenceRule copyWith(
          {String? id,
          String? accountId,
          String? description,
          int? amountCents,
          RecurrenceFrequency? frequency,
          int? interval,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          Value<int?> occurrenceCount = const Value.absent(),
          DateTime? createdAt}) =>
      RecurrenceRule(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        description: description ?? this.description,
        amountCents: amountCents ?? this.amountCents,
        frequency: frequency ?? this.frequency,
        interval: interval ?? this.interval,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        occurrenceCount: occurrenceCount.present
            ? occurrenceCount.value
            : this.occurrenceCount,
        createdAt: createdAt ?? this.createdAt,
      );
  RecurrenceRule copyWithCompanion(RecurrenceRulesCompanion data) {
    return RecurrenceRule(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      description:
          data.description.present ? data.description.value : this.description,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      interval: data.interval.present ? data.interval.value : this.interval,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      occurrenceCount: data.occurrenceCount.present
          ? data.occurrenceCount.value
          : this.occurrenceCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRule(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('occurrenceCount: $occurrenceCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountId, description, amountCents,
      frequency, interval, startDate, endDate, occurrenceCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurrenceRule &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.description == this.description &&
          other.amountCents == this.amountCents &&
          other.frequency == this.frequency &&
          other.interval == this.interval &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.occurrenceCount == this.occurrenceCount &&
          other.createdAt == this.createdAt);
}

class RecurrenceRulesCompanion extends UpdateCompanion<RecurrenceRule> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> description;
  final Value<int> amountCents;
  final Value<RecurrenceFrequency> frequency;
  final Value<int> interval;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<int?> occurrenceCount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RecurrenceRulesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.description = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.frequency = const Value.absent(),
    this.interval = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.occurrenceCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurrenceRulesCompanion.insert({
    required String id,
    required String accountId,
    required String description,
    required int amountCents,
    required RecurrenceFrequency frequency,
    required int interval,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.occurrenceCount = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        description = Value(description),
        amountCents = Value(amountCents),
        frequency = Value(frequency),
        interval = Value(interval),
        startDate = Value(startDate),
        createdAt = Value(createdAt);
  static Insertable<RecurrenceRule> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? description,
    Expression<int>? amountCents,
    Expression<int>? frequency,
    Expression<int>? interval,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? occurrenceCount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (description != null) 'description': description,
      if (amountCents != null) 'amount_cents': amountCents,
      if (frequency != null) 'frequency': frequency,
      if (interval != null) 'interval': interval,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (occurrenceCount != null) 'occurrence_count': occurrenceCount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurrenceRulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<String>? description,
      Value<int>? amountCents,
      Value<RecurrenceFrequency>? frequency,
      Value<int>? interval,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<int?>? occurrenceCount,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RecurrenceRulesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(
          $RecurrenceRulesTable.$converterfrequency.toSql(frequency.value));
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (occurrenceCount.present) {
      map['occurrence_count'] = Variable<int>(occurrenceCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRulesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('occurrenceCount: $occurrenceCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditCardsTable extends CreditCards
    with TableInfo<$CreditCardsTable, CreditCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentAccountIdMeta =
      const VerificationMeta('paymentAccountId');
  @override
  late final GeneratedColumn<String> paymentAccountId = GeneratedColumn<String>(
      'payment_account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _closingDayMeta =
      const VerificationMeta('closingDay');
  @override
  late final GeneratedColumn<int> closingDay = GeneratedColumn<int>(
      'closing_day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
      'due_day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _limitCentsMeta =
      const VerificationMeta('limitCents');
  @override
  late final GeneratedColumn<int> limitCents = GeneratedColumn<int>(
      'limit_cents', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<AccountOwner, int> owner =
      GeneratedColumn<int>('owner', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<AccountOwner>($CreditCardsTable.$converterowner);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        paymentAccountId,
        closingDay,
        dueDay,
        limitCents,
        owner,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_cards';
  @override
  VerificationContext validateIntegrity(Insertable<CreditCard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('payment_account_id')) {
      context.handle(
          _paymentAccountIdMeta,
          paymentAccountId.isAcceptableOrUnknown(
              data['payment_account_id']!, _paymentAccountIdMeta));
    } else if (isInserting) {
      context.missing(_paymentAccountIdMeta);
    }
    if (data.containsKey('closing_day')) {
      context.handle(
          _closingDayMeta,
          closingDay.isAcceptableOrUnknown(
              data['closing_day']!, _closingDayMeta));
    } else if (isInserting) {
      context.missing(_closingDayMeta);
    }
    if (data.containsKey('due_day')) {
      context.handle(_dueDayMeta,
          dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta));
    } else if (isInserting) {
      context.missing(_dueDayMeta);
    }
    if (data.containsKey('limit_cents')) {
      context.handle(
          _limitCentsMeta,
          limitCents.isAcceptableOrUnknown(
              data['limit_cents']!, _limitCentsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditCard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      paymentAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payment_account_id'])!,
      closingDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}closing_day'])!,
      dueDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_day'])!,
      limitCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}limit_cents']),
      owner: $CreditCardsTable.$converterowner.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CreditCardsTable createAlias(String alias) {
    return $CreditCardsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountOwner, int, int> $converterowner =
      const EnumIndexConverter<AccountOwner>(AccountOwner.values);
}

class CreditCard extends DataClass implements Insertable<CreditCard> {
  final String id;
  final String name;
  final String paymentAccountId;
  final int closingDay;
  final int dueDay;
  final int? limitCents;
  final AccountOwner owner;
  final DateTime createdAt;
  const CreditCard(
      {required this.id,
      required this.name,
      required this.paymentAccountId,
      required this.closingDay,
      required this.dueDay,
      this.limitCents,
      required this.owner,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['payment_account_id'] = Variable<String>(paymentAccountId);
    map['closing_day'] = Variable<int>(closingDay);
    map['due_day'] = Variable<int>(dueDay);
    if (!nullToAbsent || limitCents != null) {
      map['limit_cents'] = Variable<int>(limitCents);
    }
    {
      map['owner'] =
          Variable<int>($CreditCardsTable.$converterowner.toSql(owner));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CreditCardsCompanion toCompanion(bool nullToAbsent) {
    return CreditCardsCompanion(
      id: Value(id),
      name: Value(name),
      paymentAccountId: Value(paymentAccountId),
      closingDay: Value(closingDay),
      dueDay: Value(dueDay),
      limitCents: limitCents == null && nullToAbsent
          ? const Value.absent()
          : Value(limitCents),
      owner: Value(owner),
      createdAt: Value(createdAt),
    );
  }

  factory CreditCard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditCard(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      paymentAccountId: serializer.fromJson<String>(json['paymentAccountId']),
      closingDay: serializer.fromJson<int>(json['closingDay']),
      dueDay: serializer.fromJson<int>(json['dueDay']),
      limitCents: serializer.fromJson<int?>(json['limitCents']),
      owner: $CreditCardsTable.$converterowner
          .fromJson(serializer.fromJson<int>(json['owner'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'paymentAccountId': serializer.toJson<String>(paymentAccountId),
      'closingDay': serializer.toJson<int>(closingDay),
      'dueDay': serializer.toJson<int>(dueDay),
      'limitCents': serializer.toJson<int?>(limitCents),
      'owner': serializer
          .toJson<int>($CreditCardsTable.$converterowner.toJson(owner)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CreditCard copyWith(
          {String? id,
          String? name,
          String? paymentAccountId,
          int? closingDay,
          int? dueDay,
          Value<int?> limitCents = const Value.absent(),
          AccountOwner? owner,
          DateTime? createdAt}) =>
      CreditCard(
        id: id ?? this.id,
        name: name ?? this.name,
        paymentAccountId: paymentAccountId ?? this.paymentAccountId,
        closingDay: closingDay ?? this.closingDay,
        dueDay: dueDay ?? this.dueDay,
        limitCents: limitCents.present ? limitCents.value : this.limitCents,
        owner: owner ?? this.owner,
        createdAt: createdAt ?? this.createdAt,
      );
  CreditCard copyWithCompanion(CreditCardsCompanion data) {
    return CreditCard(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      paymentAccountId: data.paymentAccountId.present
          ? data.paymentAccountId.value
          : this.paymentAccountId,
      closingDay:
          data.closingDay.present ? data.closingDay.value : this.closingDay,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      limitCents:
          data.limitCents.present ? data.limitCents.value : this.limitCents,
      owner: data.owner.present ? data.owner.value : this.owner,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditCard(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('paymentAccountId: $paymentAccountId, ')
          ..write('closingDay: $closingDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('limitCents: $limitCents, ')
          ..write('owner: $owner, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, paymentAccountId, closingDay,
      dueDay, limitCents, owner, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditCard &&
          other.id == this.id &&
          other.name == this.name &&
          other.paymentAccountId == this.paymentAccountId &&
          other.closingDay == this.closingDay &&
          other.dueDay == this.dueDay &&
          other.limitCents == this.limitCents &&
          other.owner == this.owner &&
          other.createdAt == this.createdAt);
}

class CreditCardsCompanion extends UpdateCompanion<CreditCard> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> paymentAccountId;
  final Value<int> closingDay;
  final Value<int> dueDay;
  final Value<int?> limitCents;
  final Value<AccountOwner> owner;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CreditCardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.paymentAccountId = const Value.absent(),
    this.closingDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.limitCents = const Value.absent(),
    this.owner = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditCardsCompanion.insert({
    required String id,
    required String name,
    required String paymentAccountId,
    required int closingDay,
    required int dueDay,
    this.limitCents = const Value.absent(),
    required AccountOwner owner,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        paymentAccountId = Value(paymentAccountId),
        closingDay = Value(closingDay),
        dueDay = Value(dueDay),
        owner = Value(owner),
        createdAt = Value(createdAt);
  static Insertable<CreditCard> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? paymentAccountId,
    Expression<int>? closingDay,
    Expression<int>? dueDay,
    Expression<int>? limitCents,
    Expression<int>? owner,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (paymentAccountId != null) 'payment_account_id': paymentAccountId,
      if (closingDay != null) 'closing_day': closingDay,
      if (dueDay != null) 'due_day': dueDay,
      if (limitCents != null) 'limit_cents': limitCents,
      if (owner != null) 'owner': owner,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditCardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? paymentAccountId,
      Value<int>? closingDay,
      Value<int>? dueDay,
      Value<int?>? limitCents,
      Value<AccountOwner>? owner,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CreditCardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      paymentAccountId: paymentAccountId ?? this.paymentAccountId,
      closingDay: closingDay ?? this.closingDay,
      dueDay: dueDay ?? this.dueDay,
      limitCents: limitCents ?? this.limitCents,
      owner: owner ?? this.owner,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (paymentAccountId.present) {
      map['payment_account_id'] = Variable<String>(paymentAccountId.value);
    }
    if (closingDay.present) {
      map['closing_day'] = Variable<int>(closingDay.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (limitCents.present) {
      map['limit_cents'] = Variable<int>(limitCents.value);
    }
    if (owner.present) {
      map['owner'] =
          Variable<int>($CreditCardsTable.$converterowner.toSql(owner.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('paymentAccountId: $paymentAccountId, ')
          ..write('closingDay: $closingDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('limitCents: $limitCents, ')
          ..write('owner: $owner, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creditCardIdMeta =
      const VerificationMeta('creditCardId');
  @override
  late final GeneratedColumn<String> creditCardId = GeneratedColumn<String>(
      'credit_card_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES credit_cards (id)'));
  static const VerificationMeta _referenceMonthMeta =
      const VerificationMeta('referenceMonth');
  @override
  late final GeneratedColumn<String> referenceMonth = GeneratedColumn<String>(
      'reference_month', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _closingDateMeta =
      const VerificationMeta('closingDate');
  @override
  late final GeneratedColumn<DateTime> closingDate = GeneratedColumn<DateTime>(
      'closing_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<InvoiceStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<InvoiceStatus>($InvoicesTable.$converterstatus);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        creditCardId,
        referenceMonth,
        closingDate,
        dueDate,
        status,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(Insertable<Invoice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('credit_card_id')) {
      context.handle(
          _creditCardIdMeta,
          creditCardId.isAcceptableOrUnknown(
              data['credit_card_id']!, _creditCardIdMeta));
    } else if (isInserting) {
      context.missing(_creditCardIdMeta);
    }
    if (data.containsKey('reference_month')) {
      context.handle(
          _referenceMonthMeta,
          referenceMonth.isAcceptableOrUnknown(
              data['reference_month']!, _referenceMonthMeta));
    } else if (isInserting) {
      context.missing(_referenceMonthMeta);
    }
    if (data.containsKey('closing_date')) {
      context.handle(
          _closingDateMeta,
          closingDate.isAcceptableOrUnknown(
              data['closing_date']!, _closingDateMeta));
    } else if (isInserting) {
      context.missing(_closingDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      creditCardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}credit_card_id'])!,
      referenceMonth: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_month'])!,
      closingDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}closing_date'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      status: $InvoicesTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InvoiceStatus, int, int> $converterstatus =
      const EnumIndexConverter<InvoiceStatus>(InvoiceStatus.values);
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final String id;
  final String creditCardId;
  final String referenceMonth;
  final DateTime closingDate;
  final DateTime dueDate;
  final InvoiceStatus status;
  final DateTime createdAt;
  const Invoice(
      {required this.id,
      required this.creditCardId,
      required this.referenceMonth,
      required this.closingDate,
      required this.dueDate,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['credit_card_id'] = Variable<String>(creditCardId);
    map['reference_month'] = Variable<String>(referenceMonth);
    map['closing_date'] = Variable<DateTime>(closingDate);
    map['due_date'] = Variable<DateTime>(dueDate);
    {
      map['status'] =
          Variable<int>($InvoicesTable.$converterstatus.toSql(status));
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      creditCardId: Value(creditCardId),
      referenceMonth: Value(referenceMonth),
      closingDate: Value(closingDate),
      dueDate: Value(dueDate),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Invoice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<String>(json['id']),
      creditCardId: serializer.fromJson<String>(json['creditCardId']),
      referenceMonth: serializer.fromJson<String>(json['referenceMonth']),
      closingDate: serializer.fromJson<DateTime>(json['closingDate']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      status: $InvoicesTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'creditCardId': serializer.toJson<String>(creditCardId),
      'referenceMonth': serializer.toJson<String>(referenceMonth),
      'closingDate': serializer.toJson<DateTime>(closingDate),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'status': serializer
          .toJson<int>($InvoicesTable.$converterstatus.toJson(status)),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Invoice copyWith(
          {String? id,
          String? creditCardId,
          String? referenceMonth,
          DateTime? closingDate,
          DateTime? dueDate,
          InvoiceStatus? status,
          DateTime? createdAt}) =>
      Invoice(
        id: id ?? this.id,
        creditCardId: creditCardId ?? this.creditCardId,
        referenceMonth: referenceMonth ?? this.referenceMonth,
        closingDate: closingDate ?? this.closingDate,
        dueDate: dueDate ?? this.dueDate,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      creditCardId: data.creditCardId.present
          ? data.creditCardId.value
          : this.creditCardId,
      referenceMonth: data.referenceMonth.present
          ? data.referenceMonth.value
          : this.referenceMonth,
      closingDate:
          data.closingDate.present ? data.closingDate.value : this.closingDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('creditCardId: $creditCardId, ')
          ..write('referenceMonth: $referenceMonth, ')
          ..write('closingDate: $closingDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, creditCardId, referenceMonth, closingDate,
      dueDate, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.creditCardId == this.creditCardId &&
          other.referenceMonth == this.referenceMonth &&
          other.closingDate == this.closingDate &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<String> id;
  final Value<String> creditCardId;
  final Value<String> referenceMonth;
  final Value<DateTime> closingDate;
  final Value<DateTime> dueDate;
  final Value<InvoiceStatus> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.creditCardId = const Value.absent(),
    this.referenceMonth = const Value.absent(),
    this.closingDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String id,
    required String creditCardId,
    required String referenceMonth,
    required DateTime closingDate,
    required DateTime dueDate,
    required InvoiceStatus status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        creditCardId = Value(creditCardId),
        referenceMonth = Value(referenceMonth),
        closingDate = Value(closingDate),
        dueDate = Value(dueDate),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<Invoice> custom({
    Expression<String>? id,
    Expression<String>? creditCardId,
    Expression<String>? referenceMonth,
    Expression<DateTime>? closingDate,
    Expression<DateTime>? dueDate,
    Expression<int>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creditCardId != null) 'credit_card_id': creditCardId,
      if (referenceMonth != null) 'reference_month': referenceMonth,
      if (closingDate != null) 'closing_date': closingDate,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith(
      {Value<String>? id,
      Value<String>? creditCardId,
      Value<String>? referenceMonth,
      Value<DateTime>? closingDate,
      Value<DateTime>? dueDate,
      Value<InvoiceStatus>? status,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return InvoicesCompanion(
      id: id ?? this.id,
      creditCardId: creditCardId ?? this.creditCardId,
      referenceMonth: referenceMonth ?? this.referenceMonth,
      closingDate: closingDate ?? this.closingDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (creditCardId.present) {
      map['credit_card_id'] = Variable<String>(creditCardId.value);
    }
    if (referenceMonth.present) {
      map['reference_month'] = Variable<String>(referenceMonth.value);
    }
    if (closingDate.present) {
      map['closing_date'] = Variable<DateTime>(closingDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (status.present) {
      map['status'] =
          Variable<int>($InvoicesTable.$converterstatus.toSql(status.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('creditCardId: $creditCardId, ')
          ..write('referenceMonth: $referenceMonth, ')
          ..write('closingDate: $closingDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<TransactionStatus>(
              $TransactionsTable.$converterstatus);
  static const VerificationMeta _recurrenceRuleIdMeta =
      const VerificationMeta('recurrenceRuleId');
  @override
  late final GeneratedColumn<String> recurrenceRuleId = GeneratedColumn<String>(
      'recurrence_rule_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recurrence_rules (id)'));
  static const VerificationMeta _originalTransactionIdMeta =
      const VerificationMeta('originalTransactionId');
  @override
  late final GeneratedColumn<String> originalTransactionId =
      GeneratedColumn<String>('original_transaction_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _transferGroupIdMeta =
      const VerificationMeta('transferGroupId');
  @override
  late final GeneratedColumn<String> transferGroupId = GeneratedColumn<String>(
      'transfer_group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _invoicePaymentForIdMeta =
      const VerificationMeta('invoicePaymentForId');
  @override
  late final GeneratedColumn<String> invoicePaymentForId =
      GeneratedColumn<String>('invoice_payment_for_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints:
              GeneratedColumn.constraintIsAlways('REFERENCES invoices (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        description,
        amountCents,
        date,
        status,
        recurrenceRuleId,
        originalTransactionId,
        transferGroupId,
        invoicePaymentForId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('recurrence_rule_id')) {
      context.handle(
          _recurrenceRuleIdMeta,
          recurrenceRuleId.isAcceptableOrUnknown(
              data['recurrence_rule_id']!, _recurrenceRuleIdMeta));
    }
    if (data.containsKey('original_transaction_id')) {
      context.handle(
          _originalTransactionIdMeta,
          originalTransactionId.isAcceptableOrUnknown(
              data['original_transaction_id']!, _originalTransactionIdMeta));
    }
    if (data.containsKey('transfer_group_id')) {
      context.handle(
          _transferGroupIdMeta,
          transferGroupId.isAcceptableOrUnknown(
              data['transfer_group_id']!, _transferGroupIdMeta));
    }
    if (data.containsKey('invoice_payment_for_id')) {
      context.handle(
          _invoicePaymentForIdMeta,
          invoicePaymentForId.isAcceptableOrUnknown(
              data['invoice_payment_for_id']!, _invoicePaymentForIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      status: $TransactionsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      recurrenceRuleId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurrence_rule_id']),
      originalTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}original_transaction_id']),
      transferGroupId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transfer_group_id']),
      invoicePaymentForId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}invoice_payment_for_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionStatus, int, int> $converterstatus =
      const EnumIndexConverter<TransactionStatus>(TransactionStatus.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String accountId;
  final String description;
  final int amountCents;
  final DateTime date;
  final TransactionStatus status;
  final String? recurrenceRuleId;
  final String? originalTransactionId;
  final String? transferGroupId;
  final String? invoicePaymentForId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Transaction(
      {required this.id,
      required this.accountId,
      required this.description,
      required this.amountCents,
      required this.date,
      required this.status,
      this.recurrenceRuleId,
      this.originalTransactionId,
      this.transferGroupId,
      this.invoicePaymentForId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['description'] = Variable<String>(description);
    map['amount_cents'] = Variable<int>(amountCents);
    map['date'] = Variable<DateTime>(date);
    {
      map['status'] =
          Variable<int>($TransactionsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || recurrenceRuleId != null) {
      map['recurrence_rule_id'] = Variable<String>(recurrenceRuleId);
    }
    if (!nullToAbsent || originalTransactionId != null) {
      map['original_transaction_id'] = Variable<String>(originalTransactionId);
    }
    if (!nullToAbsent || transferGroupId != null) {
      map['transfer_group_id'] = Variable<String>(transferGroupId);
    }
    if (!nullToAbsent || invoicePaymentForId != null) {
      map['invoice_payment_for_id'] = Variable<String>(invoicePaymentForId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      description: Value(description),
      amountCents: Value(amountCents),
      date: Value(date),
      status: Value(status),
      recurrenceRuleId: recurrenceRuleId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRuleId),
      originalTransactionId: originalTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(originalTransactionId),
      transferGroupId: transferGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferGroupId),
      invoicePaymentForId: invoicePaymentForId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoicePaymentForId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      description: serializer.fromJson<String>(json['description']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: $TransactionsTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      recurrenceRuleId: serializer.fromJson<String?>(json['recurrenceRuleId']),
      originalTransactionId:
          serializer.fromJson<String?>(json['originalTransactionId']),
      transferGroupId: serializer.fromJson<String?>(json['transferGroupId']),
      invoicePaymentForId:
          serializer.fromJson<String?>(json['invoicePaymentForId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'description': serializer.toJson<String>(description),
      'amountCents': serializer.toJson<int>(amountCents),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer
          .toJson<int>($TransactionsTable.$converterstatus.toJson(status)),
      'recurrenceRuleId': serializer.toJson<String?>(recurrenceRuleId),
      'originalTransactionId':
          serializer.toJson<String?>(originalTransactionId),
      'transferGroupId': serializer.toJson<String?>(transferGroupId),
      'invoicePaymentForId': serializer.toJson<String?>(invoicePaymentForId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Transaction copyWith(
          {String? id,
          String? accountId,
          String? description,
          int? amountCents,
          DateTime? date,
          TransactionStatus? status,
          Value<String?> recurrenceRuleId = const Value.absent(),
          Value<String?> originalTransactionId = const Value.absent(),
          Value<String?> transferGroupId = const Value.absent(),
          Value<String?> invoicePaymentForId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Transaction(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        description: description ?? this.description,
        amountCents: amountCents ?? this.amountCents,
        date: date ?? this.date,
        status: status ?? this.status,
        recurrenceRuleId: recurrenceRuleId.present
            ? recurrenceRuleId.value
            : this.recurrenceRuleId,
        originalTransactionId: originalTransactionId.present
            ? originalTransactionId.value
            : this.originalTransactionId,
        transferGroupId: transferGroupId.present
            ? transferGroupId.value
            : this.transferGroupId,
        invoicePaymentForId: invoicePaymentForId.present
            ? invoicePaymentForId.value
            : this.invoicePaymentForId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      description:
          data.description.present ? data.description.value : this.description,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      recurrenceRuleId: data.recurrenceRuleId.present
          ? data.recurrenceRuleId.value
          : this.recurrenceRuleId,
      originalTransactionId: data.originalTransactionId.present
          ? data.originalTransactionId.value
          : this.originalTransactionId,
      transferGroupId: data.transferGroupId.present
          ? data.transferGroupId.value
          : this.transferGroupId,
      invoicePaymentForId: data.invoicePaymentForId.present
          ? data.invoicePaymentForId.value
          : this.invoicePaymentForId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('recurrenceRuleId: $recurrenceRuleId, ')
          ..write('originalTransactionId: $originalTransactionId, ')
          ..write('transferGroupId: $transferGroupId, ')
          ..write('invoicePaymentForId: $invoicePaymentForId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      accountId,
      description,
      amountCents,
      date,
      status,
      recurrenceRuleId,
      originalTransactionId,
      transferGroupId,
      invoicePaymentForId,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.description == this.description &&
          other.amountCents == this.amountCents &&
          other.date == this.date &&
          other.status == this.status &&
          other.recurrenceRuleId == this.recurrenceRuleId &&
          other.originalTransactionId == this.originalTransactionId &&
          other.transferGroupId == this.transferGroupId &&
          other.invoicePaymentForId == this.invoicePaymentForId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> description;
  final Value<int> amountCents;
  final Value<DateTime> date;
  final Value<TransactionStatus> status;
  final Value<String?> recurrenceRuleId;
  final Value<String?> originalTransactionId;
  final Value<String?> transferGroupId;
  final Value<String?> invoicePaymentForId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.description = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.recurrenceRuleId = const Value.absent(),
    this.originalTransactionId = const Value.absent(),
    this.transferGroupId = const Value.absent(),
    this.invoicePaymentForId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String accountId,
    required String description,
    required int amountCents,
    required DateTime date,
    required TransactionStatus status,
    this.recurrenceRuleId = const Value.absent(),
    this.originalTransactionId = const Value.absent(),
    this.transferGroupId = const Value.absent(),
    this.invoicePaymentForId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        accountId = Value(accountId),
        description = Value(description),
        amountCents = Value(amountCents),
        date = Value(date),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? description,
    Expression<int>? amountCents,
    Expression<DateTime>? date,
    Expression<int>? status,
    Expression<String>? recurrenceRuleId,
    Expression<String>? originalTransactionId,
    Expression<String>? transferGroupId,
    Expression<String>? invoicePaymentForId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (description != null) 'description': description,
      if (amountCents != null) 'amount_cents': amountCents,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (recurrenceRuleId != null) 'recurrence_rule_id': recurrenceRuleId,
      if (originalTransactionId != null)
        'original_transaction_id': originalTransactionId,
      if (transferGroupId != null) 'transfer_group_id': transferGroupId,
      if (invoicePaymentForId != null)
        'invoice_payment_for_id': invoicePaymentForId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<String>? description,
      Value<int>? amountCents,
      Value<DateTime>? date,
      Value<TransactionStatus>? status,
      Value<String?>? recurrenceRuleId,
      Value<String?>? originalTransactionId,
      Value<String?>? transferGroupId,
      Value<String?>? invoicePaymentForId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
      status: status ?? this.status,
      recurrenceRuleId: recurrenceRuleId ?? this.recurrenceRuleId,
      originalTransactionId:
          originalTransactionId ?? this.originalTransactionId,
      transferGroupId: transferGroupId ?? this.transferGroupId,
      invoicePaymentForId: invoicePaymentForId ?? this.invoicePaymentForId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $TransactionsTable.$converterstatus.toSql(status.value));
    }
    if (recurrenceRuleId.present) {
      map['recurrence_rule_id'] = Variable<String>(recurrenceRuleId.value);
    }
    if (originalTransactionId.present) {
      map['original_transaction_id'] =
          Variable<String>(originalTransactionId.value);
    }
    if (transferGroupId.present) {
      map['transfer_group_id'] = Variable<String>(transferGroupId.value);
    }
    if (invoicePaymentForId.present) {
      map['invoice_payment_for_id'] =
          Variable<String>(invoicePaymentForId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('recurrenceRuleId: $recurrenceRuleId, ')
          ..write('originalTransactionId: $originalTransactionId, ')
          ..write('transferGroupId: $transferGroupId, ')
          ..write('invoicePaymentForId: $invoicePaymentForId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTable extends InvoiceItems
    with TableInfo<$InvoiceItemsTable, InvoiceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES invoices (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _installmentNumberMeta =
      const VerificationMeta('installmentNumber');
  @override
  late final GeneratedColumn<int> installmentNumber = GeneratedColumn<int>(
      'installment_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _installmentTotalMeta =
      const VerificationMeta('installmentTotal');
  @override
  late final GeneratedColumn<int> installmentTotal = GeneratedColumn<int>(
      'installment_total', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _purchaseGroupIdMeta =
      const VerificationMeta('purchaseGroupId');
  @override
  late final GeneratedColumn<String> purchaseGroupId = GeneratedColumn<String>(
      'purchase_group_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceId,
        description,
        amountCents,
        purchaseDate,
        installmentNumber,
        installmentTotal,
        purchaseGroupId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(Insertable<InvoiceItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('installment_number')) {
      context.handle(
          _installmentNumberMeta,
          installmentNumber.isAcceptableOrUnknown(
              data['installment_number']!, _installmentNumberMeta));
    } else if (isInserting) {
      context.missing(_installmentNumberMeta);
    }
    if (data.containsKey('installment_total')) {
      context.handle(
          _installmentTotalMeta,
          installmentTotal.isAcceptableOrUnknown(
              data['installment_total']!, _installmentTotalMeta));
    } else if (isInserting) {
      context.missing(_installmentTotalMeta);
    }
    if (data.containsKey('purchase_group_id')) {
      context.handle(
          _purchaseGroupIdMeta,
          purchaseGroupId.isAcceptableOrUnknown(
              data['purchase_group_id']!, _purchaseGroupIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseGroupIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      purchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}purchase_date'])!,
      installmentNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}installment_number'])!,
      installmentTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}installment_total'])!,
      purchaseGroupId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}purchase_group_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InvoiceItemsTable createAlias(String alias) {
    return $InvoiceItemsTable(attachedDatabase, alias);
  }
}

class InvoiceItem extends DataClass implements Insertable<InvoiceItem> {
  final String id;
  final String invoiceId;
  final String description;
  final int amountCents;
  final DateTime purchaseDate;
  final int installmentNumber;
  final int installmentTotal;
  final String purchaseGroupId;
  final DateTime createdAt;
  const InvoiceItem(
      {required this.id,
      required this.invoiceId,
      required this.description,
      required this.amountCents,
      required this.purchaseDate,
      required this.installmentNumber,
      required this.installmentTotal,
      required this.purchaseGroupId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['invoice_id'] = Variable<String>(invoiceId);
    map['description'] = Variable<String>(description);
    map['amount_cents'] = Variable<int>(amountCents);
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['installment_number'] = Variable<int>(installmentNumber);
    map['installment_total'] = Variable<int>(installmentTotal);
    map['purchase_group_id'] = Variable<String>(purchaseGroupId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      description: Value(description),
      amountCents: Value(amountCents),
      purchaseDate: Value(purchaseDate),
      installmentNumber: Value(installmentNumber),
      installmentTotal: Value(installmentTotal),
      purchaseGroupId: Value(purchaseGroupId),
      createdAt: Value(createdAt),
    );
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItem(
      id: serializer.fromJson<String>(json['id']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      description: serializer.fromJson<String>(json['description']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      installmentNumber: serializer.fromJson<int>(json['installmentNumber']),
      installmentTotal: serializer.fromJson<int>(json['installmentTotal']),
      purchaseGroupId: serializer.fromJson<String>(json['purchaseGroupId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'description': serializer.toJson<String>(description),
      'amountCents': serializer.toJson<int>(amountCents),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'installmentNumber': serializer.toJson<int>(installmentNumber),
      'installmentTotal': serializer.toJson<int>(installmentTotal),
      'purchaseGroupId': serializer.toJson<String>(purchaseGroupId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InvoiceItem copyWith(
          {String? id,
          String? invoiceId,
          String? description,
          int? amountCents,
          DateTime? purchaseDate,
          int? installmentNumber,
          int? installmentTotal,
          String? purchaseGroupId,
          DateTime? createdAt}) =>
      InvoiceItem(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        description: description ?? this.description,
        amountCents: amountCents ?? this.amountCents,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        installmentNumber: installmentNumber ?? this.installmentNumber,
        installmentTotal: installmentTotal ?? this.installmentTotal,
        purchaseGroupId: purchaseGroupId ?? this.purchaseGroupId,
        createdAt: createdAt ?? this.createdAt,
      );
  InvoiceItem copyWithCompanion(InvoiceItemsCompanion data) {
    return InvoiceItem(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      description:
          data.description.present ? data.description.value : this.description,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      installmentNumber: data.installmentNumber.present
          ? data.installmentNumber.value
          : this.installmentNumber,
      installmentTotal: data.installmentTotal.present
          ? data.installmentTotal.value
          : this.installmentTotal,
      purchaseGroupId: data.purchaseGroupId.present
          ? data.purchaseGroupId.value
          : this.purchaseGroupId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItem(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('installmentNumber: $installmentNumber, ')
          ..write('installmentTotal: $installmentTotal, ')
          ..write('purchaseGroupId: $purchaseGroupId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      invoiceId,
      description,
      amountCents,
      purchaseDate,
      installmentNumber,
      installmentTotal,
      purchaseGroupId,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceItem &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.description == this.description &&
          other.amountCents == this.amountCents &&
          other.purchaseDate == this.purchaseDate &&
          other.installmentNumber == this.installmentNumber &&
          other.installmentTotal == this.installmentTotal &&
          other.purchaseGroupId == this.purchaseGroupId &&
          other.createdAt == this.createdAt);
}

class InvoiceItemsCompanion extends UpdateCompanion<InvoiceItem> {
  final Value<String> id;
  final Value<String> invoiceId;
  final Value<String> description;
  final Value<int> amountCents;
  final Value<DateTime> purchaseDate;
  final Value<int> installmentNumber;
  final Value<int> installmentTotal;
  final Value<String> purchaseGroupId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InvoiceItemsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.description = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.installmentNumber = const Value.absent(),
    this.installmentTotal = const Value.absent(),
    this.purchaseGroupId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoiceItemsCompanion.insert({
    required String id,
    required String invoiceId,
    required String description,
    required int amountCents,
    required DateTime purchaseDate,
    required int installmentNumber,
    required int installmentTotal,
    required String purchaseGroupId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        invoiceId = Value(invoiceId),
        description = Value(description),
        amountCents = Value(amountCents),
        purchaseDate = Value(purchaseDate),
        installmentNumber = Value(installmentNumber),
        installmentTotal = Value(installmentTotal),
        purchaseGroupId = Value(purchaseGroupId),
        createdAt = Value(createdAt);
  static Insertable<InvoiceItem> custom({
    Expression<String>? id,
    Expression<String>? invoiceId,
    Expression<String>? description,
    Expression<int>? amountCents,
    Expression<DateTime>? purchaseDate,
    Expression<int>? installmentNumber,
    Expression<int>? installmentTotal,
    Expression<String>? purchaseGroupId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (description != null) 'description': description,
      if (amountCents != null) 'amount_cents': amountCents,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (installmentNumber != null) 'installment_number': installmentNumber,
      if (installmentTotal != null) 'installment_total': installmentTotal,
      if (purchaseGroupId != null) 'purchase_group_id': purchaseGroupId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoiceItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? invoiceId,
      Value<String>? description,
      Value<int>? amountCents,
      Value<DateTime>? purchaseDate,
      Value<int>? installmentNumber,
      Value<int>? installmentTotal,
      Value<String>? purchaseGroupId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return InvoiceItemsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      installmentNumber: installmentNumber ?? this.installmentNumber,
      installmentTotal: installmentTotal ?? this.installmentTotal,
      purchaseGroupId: purchaseGroupId ?? this.purchaseGroupId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (installmentNumber.present) {
      map['installment_number'] = Variable<int>(installmentNumber.value);
    }
    if (installmentTotal.present) {
      map['installment_total'] = Variable<int>(installmentTotal.value);
    }
    if (purchaseGroupId.present) {
      map['purchase_group_id'] = Variable<String>(purchaseGroupId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('installmentNumber: $installmentNumber, ')
          ..write('installmentTotal: $installmentTotal, ')
          ..write('purchaseGroupId: $purchaseGroupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReservesTable extends Reserves with TableInfo<$ReservesTable, Reserve> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReservesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetAmountCentsMeta =
      const VerificationMeta('targetAmountCents');
  @override
  late final GeneratedColumn<int> targetAmountCents = GeneratedColumn<int>(
      'target_amount_cents', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currentAmountCentsMeta =
      const VerificationMeta('currentAmountCents');
  @override
  late final GeneratedColumn<int> currentAmountCents = GeneratedColumn<int>(
      'current_amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, targetAmountCents, currentAmountCents, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reserves';
  @override
  VerificationContext validateIntegrity(Insertable<Reserve> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount_cents')) {
      context.handle(
          _targetAmountCentsMeta,
          targetAmountCents.isAcceptableOrUnknown(
              data['target_amount_cents']!, _targetAmountCentsMeta));
    }
    if (data.containsKey('current_amount_cents')) {
      context.handle(
          _currentAmountCentsMeta,
          currentAmountCents.isAcceptableOrUnknown(
              data['current_amount_cents']!, _currentAmountCentsMeta));
    } else if (isInserting) {
      context.missing(_currentAmountCentsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reserve map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reserve(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      targetAmountCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}target_amount_cents']),
      currentAmountCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}current_amount_cents'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ReservesTable createAlias(String alias) {
    return $ReservesTable(attachedDatabase, alias);
  }
}

class Reserve extends DataClass implements Insertable<Reserve> {
  final String id;
  final String name;
  final int? targetAmountCents;
  final int currentAmountCents;
  final DateTime createdAt;
  const Reserve(
      {required this.id,
      required this.name,
      this.targetAmountCents,
      required this.currentAmountCents,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || targetAmountCents != null) {
      map['target_amount_cents'] = Variable<int>(targetAmountCents);
    }
    map['current_amount_cents'] = Variable<int>(currentAmountCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReservesCompanion toCompanion(bool nullToAbsent) {
    return ReservesCompanion(
      id: Value(id),
      name: Value(name),
      targetAmountCents: targetAmountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(targetAmountCents),
      currentAmountCents: Value(currentAmountCents),
      createdAt: Value(createdAt),
    );
  }

  factory Reserve.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reserve(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetAmountCents: serializer.fromJson<int?>(json['targetAmountCents']),
      currentAmountCents: serializer.fromJson<int>(json['currentAmountCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'targetAmountCents': serializer.toJson<int?>(targetAmountCents),
      'currentAmountCents': serializer.toJson<int>(currentAmountCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Reserve copyWith(
          {String? id,
          String? name,
          Value<int?> targetAmountCents = const Value.absent(),
          int? currentAmountCents,
          DateTime? createdAt}) =>
      Reserve(
        id: id ?? this.id,
        name: name ?? this.name,
        targetAmountCents: targetAmountCents.present
            ? targetAmountCents.value
            : this.targetAmountCents,
        currentAmountCents: currentAmountCents ?? this.currentAmountCents,
        createdAt: createdAt ?? this.createdAt,
      );
  Reserve copyWithCompanion(ReservesCompanion data) {
    return Reserve(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetAmountCents: data.targetAmountCents.present
          ? data.targetAmountCents.value
          : this.targetAmountCents,
      currentAmountCents: data.currentAmountCents.present
          ? data.currentAmountCents.value
          : this.currentAmountCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reserve(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmountCents: $targetAmountCents, ')
          ..write('currentAmountCents: $currentAmountCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, targetAmountCents, currentAmountCents, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reserve &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetAmountCents == this.targetAmountCents &&
          other.currentAmountCents == this.currentAmountCents &&
          other.createdAt == this.createdAt);
}

class ReservesCompanion extends UpdateCompanion<Reserve> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> targetAmountCents;
  final Value<int> currentAmountCents;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReservesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmountCents = const Value.absent(),
    this.currentAmountCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReservesCompanion.insert({
    required String id,
    required String name,
    this.targetAmountCents = const Value.absent(),
    required int currentAmountCents,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        currentAmountCents = Value(currentAmountCents),
        createdAt = Value(createdAt);
  static Insertable<Reserve> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? targetAmountCents,
    Expression<int>? currentAmountCents,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetAmountCents != null) 'target_amount_cents': targetAmountCents,
      if (currentAmountCents != null)
        'current_amount_cents': currentAmountCents,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReservesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int?>? targetAmountCents,
      Value<int>? currentAmountCents,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ReservesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmountCents: targetAmountCents ?? this.targetAmountCents,
      currentAmountCents: currentAmountCents ?? this.currentAmountCents,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmountCents.present) {
      map['target_amount_cents'] = Variable<int>(targetAmountCents.value);
    }
    if (currentAmountCents.present) {
      map['current_amount_cents'] = Variable<int>(currentAmountCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReservesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmountCents: $targetAmountCents, ')
          ..write('currentAmountCents: $currentAmountCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $RecurrenceRulesTable recurrenceRules =
      $RecurrenceRulesTable(this);
  late final $CreditCardsTable creditCards = $CreditCardsTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $InvoiceItemsTable invoiceItems = $InvoiceItemsTable(this);
  late final $ReservesTable reserves = $ReservesTable(this);
  late final AccountsDao accountsDao = AccountsDao(this as AppDatabase);
  late final TransactionsDao transactionsDao =
      TransactionsDao(this as AppDatabase);
  late final RecurrenceRulesDao recurrenceRulesDao =
      RecurrenceRulesDao(this as AppDatabase);
  late final CreditCardsDao creditCardsDao =
      CreditCardsDao(this as AppDatabase);
  late final InvoicesDao invoicesDao = InvoicesDao(this as AppDatabase);
  late final InvoiceItemsDao invoiceItemsDao =
      InvoiceItemsDao(this as AppDatabase);
  late final ReservesDao reservesDao = ReservesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accounts,
        recurrenceRules,
        creditCards,
        invoices,
        transactions,
        invoiceItems,
        reserves
      ];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required String name,
  required AccountType type,
  required AccountOwner owner,
  required int initialBalanceCents,
  required DateTime initialBalanceDate,
  Value<bool> archived,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<AccountType> type,
  Value<AccountOwner> owner,
  Value<int> initialBalanceCents,
  Value<DateTime> initialBalanceDate,
  Value<bool> archived,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecurrenceRulesTable, List<RecurrenceRule>>
      _recurrenceRulesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recurrenceRules,
              aliasName: $_aliasNameGenerator(
                  db.accounts.id, db.recurrenceRules.accountId));

  $$RecurrenceRulesTableProcessedTableManager get recurrenceRulesRefs {
    final manager = $$RecurrenceRulesTableTableManager(
            $_db, $_db.recurrenceRules)
        .filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_recurrenceRulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CreditCardsTable, List<CreditCard>>
      _creditCardsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.creditCards,
              aliasName: $_aliasNameGenerator(
                  db.accounts.id, db.creditCards.paymentAccountId));

  $$CreditCardsTableProcessedTableManager get creditCardsRefs {
    final manager = $$CreditCardsTableTableManager($_db, $_db.creditCards)
        .filter((f) =>
            f.paymentAccountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_creditCardsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.transactions,
          aliasName:
              $_aliasNameGenerator(db.accounts.id, db.transactions.accountId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AccountType, AccountType, int> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<AccountOwner, AccountOwner, int> get owner =>
      $composableBuilder(
          column: $table.owner,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get initialBalanceCents => $composableBuilder(
      column: $table.initialBalanceCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get initialBalanceDate => $composableBuilder(
      column: $table.initialBalanceDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> recurrenceRulesRefs(
      Expression<bool> Function($$RecurrenceRulesTableFilterComposer f) f) {
    final $$RecurrenceRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurrenceRules,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurrenceRulesTableFilterComposer(
              $db: $db,
              $table: $db.recurrenceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> creditCardsRefs(
      Expression<bool> Function($$CreditCardsTableFilterComposer f) f) {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.creditCards,
        getReferencedColumn: (t) => t.paymentAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditCardsTableFilterComposer(
              $db: $db,
              $table: $db.creditCards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get owner => $composableBuilder(
      column: $table.owner, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get initialBalanceCents => $composableBuilder(
      column: $table.initialBalanceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get initialBalanceDate => $composableBuilder(
      column: $table.initialBalanceDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountOwner, int> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<int> get initialBalanceCents => $composableBuilder(
      column: $table.initialBalanceCents, builder: (column) => column);

  GeneratedColumn<DateTime> get initialBalanceDate => $composableBuilder(
      column: $table.initialBalanceDate, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> recurrenceRulesRefs<T extends Object>(
      Expression<T> Function($$RecurrenceRulesTableAnnotationComposer a) f) {
    final $$RecurrenceRulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurrenceRules,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurrenceRulesTableAnnotationComposer(
              $db: $db,
              $table: $db.recurrenceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> creditCardsRefs<T extends Object>(
      Expression<T> Function($$CreditCardsTableAnnotationComposer a) f) {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.creditCards,
        getReferencedColumn: (t) => t.paymentAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditCardsTableAnnotationComposer(
              $db: $db,
              $table: $db.creditCards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function(
        {bool recurrenceRulesRefs,
        bool creditCardsRefs,
        bool transactionsRefs})> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<AccountType> type = const Value.absent(),
            Value<AccountOwner> owner = const Value.absent(),
            Value<int> initialBalanceCents = const Value.absent(),
            Value<DateTime> initialBalanceDate = const Value.absent(),
            Value<bool> archived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            name: name,
            type: type,
            owner: owner,
            initialBalanceCents: initialBalanceCents,
            initialBalanceDate: initialBalanceDate,
            archived: archived,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required AccountType type,
            required AccountOwner owner,
            required int initialBalanceCents,
            required DateTime initialBalanceDate,
            Value<bool> archived = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            name: name,
            type: type,
            owner: owner,
            initialBalanceCents: initialBalanceCents,
            initialBalanceDate: initialBalanceDate,
            archived: archived,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AccountsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {recurrenceRulesRefs = false,
              creditCardsRefs = false,
              transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recurrenceRulesRefs) db.recurrenceRules,
                if (creditCardsRefs) db.creditCards,
                if (transactionsRefs) db.transactions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recurrenceRulesRefs)
                    await $_getPrefetchedData<Account, $AccountsTable,
                            RecurrenceRule>(
                        currentTable: table,
                        referencedTable: $$AccountsTableReferences
                            ._recurrenceRulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0)
                                .recurrenceRulesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items),
                  if (creditCardsRefs)
                    await $_getPrefetchedData<Account, $AccountsTable,
                            CreditCard>(
                        currentTable: table,
                        referencedTable:
                            $$AccountsTableReferences._creditCardsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0)
                                .creditCardsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.paymentAccountId == item.id),
                        typedResults: items),
                  if (transactionsRefs)
                    await $_getPrefetchedData<Account, $AccountsTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable: $$AccountsTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function(
        {bool recurrenceRulesRefs,
        bool creditCardsRefs,
        bool transactionsRefs})>;
typedef $$RecurrenceRulesTableCreateCompanionBuilder = RecurrenceRulesCompanion
    Function({
  required String id,
  required String accountId,
  required String description,
  required int amountCents,
  required RecurrenceFrequency frequency,
  required int interval,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<int?> occurrenceCount,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$RecurrenceRulesTableUpdateCompanionBuilder = RecurrenceRulesCompanion
    Function({
  Value<String> id,
  Value<String> accountId,
  Value<String> description,
  Value<int> amountCents,
  Value<RecurrenceFrequency> frequency,
  Value<int> interval,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<int?> occurrenceCount,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$RecurrenceRulesTableReferences extends BaseReferences<
    _$AppDatabase, $RecurrenceRulesTable, RecurrenceRule> {
  $$RecurrenceRulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
          $_aliasNameGenerator(db.recurrenceRules.accountId, db.accounts.id));

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.recurrenceRules.id, db.transactions.recurrenceRuleId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) =>
            f.recurrenceRuleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecurrenceRulesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurrenceRulesTable> {
  $$RecurrenceRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RecurrenceFrequency, RecurrenceFrequency, int>
      get frequency => $composableBuilder(
          column: $table.frequency,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get occurrenceCount => $composableBuilder(
      column: $table.occurrenceCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.recurrenceRuleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecurrenceRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurrenceRulesTable> {
  $$RecurrenceRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get occurrenceCount => $composableBuilder(
      column: $table.occurrenceCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurrenceRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurrenceRulesTable> {
  $$RecurrenceRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecurrenceFrequency, int> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get occurrenceCount => $composableBuilder(
      column: $table.occurrenceCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.recurrenceRuleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecurrenceRulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurrenceRulesTable,
    RecurrenceRule,
    $$RecurrenceRulesTableFilterComposer,
    $$RecurrenceRulesTableOrderingComposer,
    $$RecurrenceRulesTableAnnotationComposer,
    $$RecurrenceRulesTableCreateCompanionBuilder,
    $$RecurrenceRulesTableUpdateCompanionBuilder,
    (RecurrenceRule, $$RecurrenceRulesTableReferences),
    RecurrenceRule,
    PrefetchHooks Function({bool accountId, bool transactionsRefs})> {
  $$RecurrenceRulesTableTableManager(
      _$AppDatabase db, $RecurrenceRulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrenceRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurrenceRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurrenceRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<RecurrenceFrequency> frequency = const Value.absent(),
            Value<int> interval = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<int?> occurrenceCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurrenceRulesCompanion(
            id: id,
            accountId: accountId,
            description: description,
            amountCents: amountCents,
            frequency: frequency,
            interval: interval,
            startDate: startDate,
            endDate: endDate,
            occurrenceCount: occurrenceCount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String accountId,
            required String description,
            required int amountCents,
            required RecurrenceFrequency frequency,
            required int interval,
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<int?> occurrenceCount = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurrenceRulesCompanion.insert(
            id: id,
            accountId: accountId,
            description: description,
            amountCents: amountCents,
            frequency: frequency,
            interval: interval,
            startDate: startDate,
            endDate: endDate,
            occurrenceCount: occurrenceCount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecurrenceRulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {accountId = false, transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$RecurrenceRulesTableReferences._accountIdTable(db),
                    referencedColumn:
                        $$RecurrenceRulesTableReferences._accountIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<RecurrenceRule,
                            $RecurrenceRulesTable, Transaction>(
                        currentTable: table,
                        referencedTable: $$RecurrenceRulesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecurrenceRulesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.recurrenceRuleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RecurrenceRulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecurrenceRulesTable,
    RecurrenceRule,
    $$RecurrenceRulesTableFilterComposer,
    $$RecurrenceRulesTableOrderingComposer,
    $$RecurrenceRulesTableAnnotationComposer,
    $$RecurrenceRulesTableCreateCompanionBuilder,
    $$RecurrenceRulesTableUpdateCompanionBuilder,
    (RecurrenceRule, $$RecurrenceRulesTableReferences),
    RecurrenceRule,
    PrefetchHooks Function({bool accountId, bool transactionsRefs})>;
typedef $$CreditCardsTableCreateCompanionBuilder = CreditCardsCompanion
    Function({
  required String id,
  required String name,
  required String paymentAccountId,
  required int closingDay,
  required int dueDay,
  Value<int?> limitCents,
  required AccountOwner owner,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CreditCardsTableUpdateCompanionBuilder = CreditCardsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> paymentAccountId,
  Value<int> closingDay,
  Value<int> dueDay,
  Value<int?> limitCents,
  Value<AccountOwner> owner,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CreditCardsTableReferences
    extends BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCard> {
  $$CreditCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _paymentAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias($_aliasNameGenerator(
          db.creditCards.paymentAccountId, db.accounts.id));

  $$AccountsTableProcessedTableManager get paymentAccountId {
    final $_column = $_itemColumn<String>('payment_account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.invoices,
          aliasName: $_aliasNameGenerator(
              db.creditCards.id, db.invoices.creditCardId));

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager($_db, $_db.invoices).filter(
        (f) => f.creditCardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CreditCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get closingDay => $composableBuilder(
      column: $table.closingDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueDay => $composableBuilder(
      column: $table.dueDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get limitCents => $composableBuilder(
      column: $table.limitCents, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AccountOwner, AccountOwner, int> get owner =>
      $composableBuilder(
          column: $table.owner,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$AccountsTableFilterComposer get paymentAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> invoicesRefs(
      Expression<bool> Function($$InvoicesTableFilterComposer f) f) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.creditCardId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableFilterComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CreditCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get closingDay => $composableBuilder(
      column: $table.closingDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueDay => $composableBuilder(
      column: $table.dueDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get limitCents => $composableBuilder(
      column: $table.limitCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get owner => $composableBuilder(
      column: $table.owner, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$AccountsTableOrderingComposer get paymentAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CreditCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get closingDay => $composableBuilder(
      column: $table.closingDay, builder: (column) => column);

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<int> get limitCents => $composableBuilder(
      column: $table.limitCents, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountOwner, int> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get paymentAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> invoicesRefs<T extends Object>(
      Expression<T> Function($$InvoicesTableAnnotationComposer a) f) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.creditCardId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CreditCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CreditCardsTable,
    CreditCard,
    $$CreditCardsTableFilterComposer,
    $$CreditCardsTableOrderingComposer,
    $$CreditCardsTableAnnotationComposer,
    $$CreditCardsTableCreateCompanionBuilder,
    $$CreditCardsTableUpdateCompanionBuilder,
    (CreditCard, $$CreditCardsTableReferences),
    CreditCard,
    PrefetchHooks Function({bool paymentAccountId, bool invoicesRefs})> {
  $$CreditCardsTableTableManager(_$AppDatabase db, $CreditCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> paymentAccountId = const Value.absent(),
            Value<int> closingDay = const Value.absent(),
            Value<int> dueDay = const Value.absent(),
            Value<int?> limitCents = const Value.absent(),
            Value<AccountOwner> owner = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardsCompanion(
            id: id,
            name: name,
            paymentAccountId: paymentAccountId,
            closingDay: closingDay,
            dueDay: dueDay,
            limitCents: limitCents,
            owner: owner,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String paymentAccountId,
            required int closingDay,
            required int dueDay,
            Value<int?> limitCents = const Value.absent(),
            required AccountOwner owner,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardsCompanion.insert(
            id: id,
            name: name,
            paymentAccountId: paymentAccountId,
            closingDay: closingDay,
            dueDay: dueDay,
            limitCents: limitCents,
            owner: owner,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CreditCardsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {paymentAccountId = false, invoicesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (invoicesRefs) db.invoices],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (paymentAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.paymentAccountId,
                    referencedTable:
                        $$CreditCardsTableReferences._paymentAccountIdTable(db),
                    referencedColumn: $$CreditCardsTableReferences
                        ._paymentAccountIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (invoicesRefs)
                    await $_getPrefetchedData<CreditCard, $CreditCardsTable,
                            Invoice>(
                        currentTable: table,
                        referencedTable:
                            $$CreditCardsTableReferences._invoicesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CreditCardsTableReferences(db, table, p0)
                                .invoicesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.creditCardId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CreditCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CreditCardsTable,
    CreditCard,
    $$CreditCardsTableFilterComposer,
    $$CreditCardsTableOrderingComposer,
    $$CreditCardsTableAnnotationComposer,
    $$CreditCardsTableCreateCompanionBuilder,
    $$CreditCardsTableUpdateCompanionBuilder,
    (CreditCard, $$CreditCardsTableReferences),
    CreditCard,
    PrefetchHooks Function({bool paymentAccountId, bool invoicesRefs})>;
typedef $$InvoicesTableCreateCompanionBuilder = InvoicesCompanion Function({
  required String id,
  required String creditCardId,
  required String referenceMonth,
  required DateTime closingDate,
  required DateTime dueDate,
  required InvoiceStatus status,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$InvoicesTableUpdateCompanionBuilder = InvoicesCompanion Function({
  Value<String> id,
  Value<String> creditCardId,
  Value<String> referenceMonth,
  Value<DateTime> closingDate,
  Value<DateTime> dueDate,
  Value<InvoiceStatus> status,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, Invoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CreditCardsTable _creditCardIdTable(_$AppDatabase db) =>
      db.creditCards.createAlias(
          $_aliasNameGenerator(db.invoices.creditCardId, db.creditCards.id));

  $$CreditCardsTableProcessedTableManager get creditCardId {
    final $_column = $_itemColumn<String>('credit_card_id')!;

    final manager = $$CreditCardsTableTableManager($_db, $_db.creditCards)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_creditCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.invoices.id, db.transactions.invoicePaymentForId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) =>
            f.invoicePaymentForId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$InvoiceItemsTable, List<InvoiceItem>>
      _invoiceItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.invoiceItems,
          aliasName:
              $_aliasNameGenerator(db.invoices.id, db.invoiceItems.invoiceId));

  $$InvoiceItemsTableProcessedTableManager get invoiceItemsRefs {
    final manager = $$InvoiceItemsTableTableManager($_db, $_db.invoiceItems)
        .filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceMonth => $composableBuilder(
      column: $table.referenceMonth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closingDate => $composableBuilder(
      column: $table.closingDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<InvoiceStatus, InvoiceStatus, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CreditCardsTableFilterComposer get creditCardId {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.creditCardId,
        referencedTable: $db.creditCards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditCardsTableFilterComposer(
              $db: $db,
              $table: $db.creditCards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.invoicePaymentForId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> invoiceItemsRefs(
      Expression<bool> Function($$InvoiceItemsTableFilterComposer f) f) {
    final $$InvoiceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.invoiceItems,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoiceItemsTableFilterComposer(
              $db: $db,
              $table: $db.invoiceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceMonth => $composableBuilder(
      column: $table.referenceMonth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closingDate => $composableBuilder(
      column: $table.closingDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CreditCardsTableOrderingComposer get creditCardId {
    final $$CreditCardsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.creditCardId,
        referencedTable: $db.creditCards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditCardsTableOrderingComposer(
              $db: $db,
              $table: $db.creditCards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get referenceMonth => $composableBuilder(
      column: $table.referenceMonth, builder: (column) => column);

  GeneratedColumn<DateTime> get closingDate => $composableBuilder(
      column: $table.closingDate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InvoiceStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CreditCardsTableAnnotationComposer get creditCardId {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.creditCardId,
        referencedTable: $db.creditCards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CreditCardsTableAnnotationComposer(
              $db: $db,
              $table: $db.creditCards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.invoicePaymentForId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> invoiceItemsRefs<T extends Object>(
      Expression<T> Function($$InvoiceItemsTableAnnotationComposer a) f) {
    final $$InvoiceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.invoiceItems,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoiceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.invoiceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InvoicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvoicesTable,
    Invoice,
    $$InvoicesTableFilterComposer,
    $$InvoicesTableOrderingComposer,
    $$InvoicesTableAnnotationComposer,
    $$InvoicesTableCreateCompanionBuilder,
    $$InvoicesTableUpdateCompanionBuilder,
    (Invoice, $$InvoicesTableReferences),
    Invoice,
    PrefetchHooks Function(
        {bool creditCardId, bool transactionsRefs, bool invoiceItemsRefs})> {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> creditCardId = const Value.absent(),
            Value<String> referenceMonth = const Value.absent(),
            Value<DateTime> closingDate = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<InvoiceStatus> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvoicesCompanion(
            id: id,
            creditCardId: creditCardId,
            referenceMonth: referenceMonth,
            closingDate: closingDate,
            dueDate: dueDate,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String creditCardId,
            required String referenceMonth,
            required DateTime closingDate,
            required DateTime dueDate,
            required InvoiceStatus status,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              InvoicesCompanion.insert(
            id: id,
            creditCardId: creditCardId,
            referenceMonth: referenceMonth,
            closingDate: closingDate,
            dueDate: dueDate,
            status: status,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$InvoicesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {creditCardId = false,
              transactionsRefs = false,
              invoiceItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsRefs) db.transactions,
                if (invoiceItemsRefs) db.invoiceItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (creditCardId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.creditCardId,
                    referencedTable:
                        $$InvoicesTableReferences._creditCardIdTable(db),
                    referencedColumn:
                        $$InvoicesTableReferences._creditCardIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<Invoice, $InvoicesTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable: $$InvoicesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InvoicesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.invoicePaymentForId == item.id),
                        typedResults: items),
                  if (invoiceItemsRefs)
                    await $_getPrefetchedData<Invoice, $InvoicesTable,
                            InvoiceItem>(
                        currentTable: table,
                        referencedTable: $$InvoicesTableReferences
                            ._invoiceItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InvoicesTableReferences(db, table, p0)
                                .invoiceItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.invoiceId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InvoicesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InvoicesTable,
    Invoice,
    $$InvoicesTableFilterComposer,
    $$InvoicesTableOrderingComposer,
    $$InvoicesTableAnnotationComposer,
    $$InvoicesTableCreateCompanionBuilder,
    $$InvoicesTableUpdateCompanionBuilder,
    (Invoice, $$InvoicesTableReferences),
    Invoice,
    PrefetchHooks Function(
        {bool creditCardId, bool transactionsRefs, bool invoiceItemsRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required String accountId,
  required String description,
  required int amountCents,
  required DateTime date,
  required TransactionStatus status,
  Value<String?> recurrenceRuleId,
  Value<String?> originalTransactionId,
  Value<String?> transferGroupId,
  Value<String?> invoicePaymentForId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> accountId,
  Value<String> description,
  Value<int> amountCents,
  Value<DateTime> date,
  Value<TransactionStatus> status,
  Value<String?> recurrenceRuleId,
  Value<String?> originalTransactionId,
  Value<String?> transferGroupId,
  Value<String?> invoicePaymentForId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
          $_aliasNameGenerator(db.transactions.accountId, db.accounts.id));

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RecurrenceRulesTable _recurrenceRuleIdTable(_$AppDatabase db) =>
      db.recurrenceRules.createAlias($_aliasNameGenerator(
          db.transactions.recurrenceRuleId, db.recurrenceRules.id));

  $$RecurrenceRulesTableProcessedTableManager? get recurrenceRuleId {
    final $_column = $_itemColumn<String>('recurrence_rule_id');
    if ($_column == null) return null;
    final manager =
        $$RecurrenceRulesTableTableManager($_db, $_db.recurrenceRules)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurrenceRuleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $InvoicesTable _invoicePaymentForIdTable(_$AppDatabase db) =>
      db.invoices.createAlias($_aliasNameGenerator(
          db.transactions.invoicePaymentForId, db.invoices.id));

  $$InvoicesTableProcessedTableManager? get invoicePaymentForId {
    final $_column = $_itemColumn<String>('invoice_payment_for_id');
    if ($_column == null) return null;
    final manager = $$InvoicesTableTableManager($_db, $_db.invoices)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoicePaymentForIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionStatus, TransactionStatus, int>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get originalTransactionId => $composableBuilder(
      column: $table.originalTransactionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transferGroupId => $composableBuilder(
      column: $table.transferGroupId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecurrenceRulesTableFilterComposer get recurrenceRuleId {
    final $$RecurrenceRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recurrenceRuleId,
        referencedTable: $db.recurrenceRules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurrenceRulesTableFilterComposer(
              $db: $db,
              $table: $db.recurrenceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InvoicesTableFilterComposer get invoicePaymentForId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoicePaymentForId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableFilterComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalTransactionId => $composableBuilder(
      column: $table.originalTransactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transferGroupId => $composableBuilder(
      column: $table.transferGroupId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecurrenceRulesTableOrderingComposer get recurrenceRuleId {
    final $$RecurrenceRulesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recurrenceRuleId,
        referencedTable: $db.recurrenceRules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurrenceRulesTableOrderingComposer(
              $db: $db,
              $table: $db.recurrenceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InvoicesTableOrderingComposer get invoicePaymentForId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoicePaymentForId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableOrderingComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get originalTransactionId => $composableBuilder(
      column: $table.originalTransactionId, builder: (column) => column);

  GeneratedColumn<String> get transferGroupId => $composableBuilder(
      column: $table.transferGroupId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecurrenceRulesTableAnnotationComposer get recurrenceRuleId {
    final $$RecurrenceRulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recurrenceRuleId,
        referencedTable: $db.recurrenceRules,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurrenceRulesTableAnnotationComposer(
              $db: $db,
              $table: $db.recurrenceRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$InvoicesTableAnnotationComposer get invoicePaymentForId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoicePaymentForId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool accountId, bool recurrenceRuleId, bool invoicePaymentForId})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<TransactionStatus> status = const Value.absent(),
            Value<String?> recurrenceRuleId = const Value.absent(),
            Value<String?> originalTransactionId = const Value.absent(),
            Value<String?> transferGroupId = const Value.absent(),
            Value<String?> invoicePaymentForId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            accountId: accountId,
            description: description,
            amountCents: amountCents,
            date: date,
            status: status,
            recurrenceRuleId: recurrenceRuleId,
            originalTransactionId: originalTransactionId,
            transferGroupId: transferGroupId,
            invoicePaymentForId: invoicePaymentForId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String accountId,
            required String description,
            required int amountCents,
            required DateTime date,
            required TransactionStatus status,
            Value<String?> recurrenceRuleId = const Value.absent(),
            Value<String?> originalTransactionId = const Value.absent(),
            Value<String?> transferGroupId = const Value.absent(),
            Value<String?> invoicePaymentForId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            accountId: accountId,
            description: description,
            amountCents: amountCents,
            date: date,
            status: status,
            recurrenceRuleId: recurrenceRuleId,
            originalTransactionId: originalTransactionId,
            transferGroupId: transferGroupId,
            invoicePaymentForId: invoicePaymentForId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {accountId = false,
              recurrenceRuleId = false,
              invoicePaymentForId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$TransactionsTableReferences._accountIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._accountIdTable(db).id,
                  ) as T;
                }
                if (recurrenceRuleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recurrenceRuleId,
                    referencedTable: $$TransactionsTableReferences
                        ._recurrenceRuleIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._recurrenceRuleIdTable(db)
                        .id,
                  ) as T;
                }
                if (invoicePaymentForId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.invoicePaymentForId,
                    referencedTable: $$TransactionsTableReferences
                        ._invoicePaymentForIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._invoicePaymentForIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool accountId, bool recurrenceRuleId, bool invoicePaymentForId})>;
typedef $$InvoiceItemsTableCreateCompanionBuilder = InvoiceItemsCompanion
    Function({
  required String id,
  required String invoiceId,
  required String description,
  required int amountCents,
  required DateTime purchaseDate,
  required int installmentNumber,
  required int installmentTotal,
  required String purchaseGroupId,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$InvoiceItemsTableUpdateCompanionBuilder = InvoiceItemsCompanion
    Function({
  Value<String> id,
  Value<String> invoiceId,
  Value<String> description,
  Value<int> amountCents,
  Value<DateTime> purchaseDate,
  Value<int> installmentNumber,
  Value<int> installmentTotal,
  Value<String> purchaseGroupId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$InvoiceItemsTableReferences
    extends BaseReferences<_$AppDatabase, $InvoiceItemsTable, InvoiceItem> {
  $$InvoiceItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias(
          $_aliasNameGenerator(db.invoiceItems.invoiceId, db.invoices.id));

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager($_db, $_db.invoices)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InvoiceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installmentNumber => $composableBuilder(
      column: $table.installmentNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installmentTotal => $composableBuilder(
      column: $table.installmentTotal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseGroupId => $composableBuilder(
      column: $table.purchaseGroupId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableFilterComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoiceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installmentNumber => $composableBuilder(
      column: $table.installmentNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installmentTotal => $composableBuilder(
      column: $table.installmentTotal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseGroupId => $composableBuilder(
      column: $table.purchaseGroupId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableOrderingComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoiceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<int> get installmentNumber => $composableBuilder(
      column: $table.installmentNumber, builder: (column) => column);

  GeneratedColumn<int> get installmentTotal => $composableBuilder(
      column: $table.installmentTotal, builder: (column) => column);

  GeneratedColumn<String> get purchaseGroupId => $composableBuilder(
      column: $table.purchaseGroupId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoiceItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvoiceItemsTable,
    InvoiceItem,
    $$InvoiceItemsTableFilterComposer,
    $$InvoiceItemsTableOrderingComposer,
    $$InvoiceItemsTableAnnotationComposer,
    $$InvoiceItemsTableCreateCompanionBuilder,
    $$InvoiceItemsTableUpdateCompanionBuilder,
    (InvoiceItem, $$InvoiceItemsTableReferences),
    InvoiceItem,
    PrefetchHooks Function({bool invoiceId})> {
  $$InvoiceItemsTableTableManager(_$AppDatabase db, $InvoiceItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> invoiceId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<int> installmentNumber = const Value.absent(),
            Value<int> installmentTotal = const Value.absent(),
            Value<String> purchaseGroupId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvoiceItemsCompanion(
            id: id,
            invoiceId: invoiceId,
            description: description,
            amountCents: amountCents,
            purchaseDate: purchaseDate,
            installmentNumber: installmentNumber,
            installmentTotal: installmentTotal,
            purchaseGroupId: purchaseGroupId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String invoiceId,
            required String description,
            required int amountCents,
            required DateTime purchaseDate,
            required int installmentNumber,
            required int installmentTotal,
            required String purchaseGroupId,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              InvoiceItemsCompanion.insert(
            id: id,
            invoiceId: invoiceId,
            description: description,
            amountCents: amountCents,
            purchaseDate: purchaseDate,
            installmentNumber: installmentNumber,
            installmentTotal: installmentTotal,
            purchaseGroupId: purchaseGroupId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InvoiceItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (invoiceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.invoiceId,
                    referencedTable:
                        $$InvoiceItemsTableReferences._invoiceIdTable(db),
                    referencedColumn:
                        $$InvoiceItemsTableReferences._invoiceIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$InvoiceItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InvoiceItemsTable,
    InvoiceItem,
    $$InvoiceItemsTableFilterComposer,
    $$InvoiceItemsTableOrderingComposer,
    $$InvoiceItemsTableAnnotationComposer,
    $$InvoiceItemsTableCreateCompanionBuilder,
    $$InvoiceItemsTableUpdateCompanionBuilder,
    (InvoiceItem, $$InvoiceItemsTableReferences),
    InvoiceItem,
    PrefetchHooks Function({bool invoiceId})>;
typedef $$ReservesTableCreateCompanionBuilder = ReservesCompanion Function({
  required String id,
  required String name,
  Value<int?> targetAmountCents,
  required int currentAmountCents,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ReservesTableUpdateCompanionBuilder = ReservesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int?> targetAmountCents,
  Value<int> currentAmountCents,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ReservesTableFilterComposer
    extends Composer<_$AppDatabase, $ReservesTable> {
  $$ReservesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetAmountCents => $composableBuilder(
      column: $table.targetAmountCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentAmountCents => $composableBuilder(
      column: $table.currentAmountCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ReservesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReservesTable> {
  $$ReservesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetAmountCents => $composableBuilder(
      column: $table.targetAmountCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentAmountCents => $composableBuilder(
      column: $table.currentAmountCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ReservesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReservesTable> {
  $$ReservesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetAmountCents => $composableBuilder(
      column: $table.targetAmountCents, builder: (column) => column);

  GeneratedColumn<int> get currentAmountCents => $composableBuilder(
      column: $table.currentAmountCents, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReservesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReservesTable,
    Reserve,
    $$ReservesTableFilterComposer,
    $$ReservesTableOrderingComposer,
    $$ReservesTableAnnotationComposer,
    $$ReservesTableCreateCompanionBuilder,
    $$ReservesTableUpdateCompanionBuilder,
    (Reserve, BaseReferences<_$AppDatabase, $ReservesTable, Reserve>),
    Reserve,
    PrefetchHooks Function()> {
  $$ReservesTableTableManager(_$AppDatabase db, $ReservesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReservesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReservesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReservesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> targetAmountCents = const Value.absent(),
            Value<int> currentAmountCents = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservesCompanion(
            id: id,
            name: name,
            targetAmountCents: targetAmountCents,
            currentAmountCents: currentAmountCents,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int?> targetAmountCents = const Value.absent(),
            required int currentAmountCents,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservesCompanion.insert(
            id: id,
            name: name,
            targetAmountCents: targetAmountCents,
            currentAmountCents: currentAmountCents,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReservesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReservesTable,
    Reserve,
    $$ReservesTableFilterComposer,
    $$ReservesTableOrderingComposer,
    $$ReservesTableAnnotationComposer,
    $$ReservesTableCreateCompanionBuilder,
    $$ReservesTableUpdateCompanionBuilder,
    (Reserve, BaseReferences<_$AppDatabase, $ReservesTable, Reserve>),
    Reserve,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$RecurrenceRulesTableTableManager get recurrenceRules =>
      $$RecurrenceRulesTableTableManager(_db, _db.recurrenceRules);
  $$CreditCardsTableTableManager get creditCards =>
      $$CreditCardsTableTableManager(_db, _db.creditCards);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$InvoiceItemsTableTableManager get invoiceItems =>
      $$InvoiceItemsTableTableManager(_db, _db.invoiceItems);
  $$ReservesTableTableManager get reserves =>
      $$ReservesTableTableManager(_db, _db.reserves);
}

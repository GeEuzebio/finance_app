import 'package:uuid/uuid.dart';

import '../../../../core/utils/date_only.dart';

/// Id determinístico pro override de uma ocorrência de recorrência em
/// (recurrenceRuleId, date). Qualquer código que crie/atualize essa
/// Transaction PRECISA usar esta mesma função — senão dois fluxos
/// diferentes (editar 1 ocorrência, check-in) criam duas linhas pra mesma
/// ocorrência em vez de uma só. A engine casa overrides por esse par exato
/// (docs/CASHFLOW_ENGINE.md §2 passo 2).
String recurrenceOverrideId(String recurrenceRuleId, DateOnly date) =>
    const Uuid().v5(Namespace.url.value, '$recurrenceRuleId|$date');

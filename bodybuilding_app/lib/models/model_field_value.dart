/// Wraps a value for [copyWithModelFieldValues] so callers can distinguish
/// “leave unchanged” from “set to null”.
class ModelFieldValue<T> {
  const ModelFieldValue.value(this.value);

  final T value;
}

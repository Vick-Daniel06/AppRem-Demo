//Clase para el manehjo de errores
//sealed solo tiene dos reultados, Success and Failure
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data); //optiona data
}

class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}
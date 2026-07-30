enum Architecture {
  none('None'),
  clean('Clean Architecture'),
  mvc('MVC'),
  mvvm('MVVM'),
  mvp('MVP');

  const Architecture(this.label);

  final String label;
}

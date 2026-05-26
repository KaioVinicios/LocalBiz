enum AppRoute {
  home('/home'),
  dashboard('/dashboard'),
  login('/login'),
  forgotPassword('/recuperar-senha'),
  register('/signin'),
  clientes('/clientes'),
  produtos('/produtos'),
  configuracoes('/configuracoes'),
  vendas('/vendas'),
  services('/services'),
  serviceCreate('/services/new'),
  serviceEdit('/services/edit'),
  serviceDetails('/service-details'),
  serviceSchedules('/service-schedules'),
  configuration('/configuration'),
  businessProfile('/business-profile'),
  report('/report'),
  relatorios('/relatorios');

  const AppRoute(this.path);

  final String path;
}

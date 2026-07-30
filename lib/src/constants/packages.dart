import 'package:arise/src/models/package_info.dart';

const noPackages = <PackageInfo>[];

const providerPackages = [PackageInfo(name: 'provider')];

const riverpodPackages = [PackageInfo(name: 'flutter_riverpod')];

const blocPackages = [
  PackageInfo(name: 'flutter_bloc'),
  PackageInfo(name: 'bloc'),
];

const getxPackages = [PackageInfo(name: 'get')];

const dioPackages = [PackageInfo(name: 'dio')];

const goRouterPackages = [PackageInfo(name: 'go_router')];

const autoRoutePackages = [
  PackageInfo(name: 'auto_route'),
  PackageInfo(name: 'auto_route_generator', isDevDependency: true),
  PackageInfo(name: 'build_runner', isDevDependency: true),
];

List<PackageInfo> getStateManagementPackages(String stateManagement) {
  switch (stateManagement) {
    case 'Provider':
      return providerPackages;

    case 'Riverpod':
      return riverpodPackages;

    case 'Bloc':
      return blocPackages;

    case 'GetX':
      return getxPackages;

    case 'None':
    default:
      return noPackages;
  }
}

List<PackageInfo> getRoutingPackages(String routing) {
  switch (routing) {
    case 'GoRouter':
      return goRouterPackages;

    case 'AutoRoute':
      return autoRoutePackages;

    case 'None':
    default:
      return noPackages;
  }
}

List<PackageInfo> getNetworkingPackages(String networking) {
  switch (networking) {
    case 'Dio':
      return dioPackages;

    case 'None':
    default:
      return noPackages;
  }
}

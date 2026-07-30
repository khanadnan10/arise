import 'package:arise/src/models/package_info.dart';
import '../models/state_management.dart';
import '../models/routing.dart';

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

List<PackageInfo> getStateManagementPackages(
  StateManagement stateManagement,
) {
  switch (stateManagement) {
    case StateManagement.provider:
      return providerPackages;

    case StateManagement.riverpod:
      return riverpodPackages;

    case StateManagement.bloc:
      return blocPackages;

    case StateManagement.getx:
      return getxPackages;

    case StateManagement.none:
      return noPackages;
  }
}

List<PackageInfo> getRoutingPackages(
  Routing routing,
) {
  switch (routing) {
    case Routing.goRouter:
      return goRouterPackages;

    case Routing.autoRoute:
      return autoRoutePackages;

    case Routing.none:
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

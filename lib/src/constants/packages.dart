const riverpodPackages = ['flutter_riverpod'];

const goRouterPackages = ['go_router'];

const dioPackages = ['dio'];

List<String> getStateManagementPackages(String stateManagement) {
  switch (stateManagement) {
    case 'Riverpod':
      return riverpodPackages;
    default:
      return [];
  }
}

List<String> getRoutingPackages(String routing) {
  switch (routing) {
    case 'GoRouter':
      return goRouterPackages;
    default:
      return [];
  }
}

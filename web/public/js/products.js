angular.module('cleanAirApp', [])
.controller('suggestCtrl', function($scope, $http) {
  $scope.mode = 'form';

  $scope.area = 15;
  $scope.height = 2.8;
  $scope.cycles = 4;

  $scope.products = [];

  $scope.setCycles = function(value) {
    $scope.cycles = value;
  }

  $scope.cyclesLevel = function() {
    if($scope.cycles == 5) {
      return '优秀';
    } else if($scope.cycles == 4) {
      return '良好';
    } else if($scope.cycles == 3) {
      return '一般';
    }
  }

  $scope.search = function() {
    var baseUrl = '/products?mode=suggest';
    baseUrl += '&room_area=' + $scope.area;
    baseUrl += '&air_refresh_count=' + $scope.cycles;
    baseUrl += '&room_height=' + $scope.height;

    console.log(baseUrl);
    $http.get(baseUrl).success(function(data) {
      $scope.mode = 'results';
      $scope.products = data;
    });
  }
})
.controller('searchCtrl', function($scope, $http) {
  $scope.area = 15;
  $scope.height = 2.8;
  $scope.modelId = 1365;

  $http.get('/all_brands_models').success(function(data) {
    $scope.products = data;
  });
})
.controller('productCtrl', function($scope, $http) {
  $scope.product = {}

  var baseUrl = '/products/' + location.search.split('id=')[1];
  $http.get(baseUrl).success(function(data) {
    $scope.product = data;
  });
})

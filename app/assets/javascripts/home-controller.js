app.controller('HomeController', ['$scope', '$http', function($scope, $http){
  $scope.logout = function(){
    $http({method: 'delete', url: '/users/sign_out'}).success(function(){
      window.location.replace('/');
    });
  };
}]);

app.controller('UserController', ['$scope', '$http', function($scope, $http){
  $scope.user = {
    email: "",
    password: ""
  };
  $scope.loginError = false;
  $scope.login = function(){
    $http.post("/users/sign_in", {user: $scope.user})
    .success(function(data, status){
      window.location.replace('/');
    })
    .error(function(data, status){
      $scope.loginError = true;
      $scope.loginErrorMsg = data.error;
    });
  };  
  $scope.signup= function(){
    $http.post("/users", {user: $scope.user})
    .success(function(data, status){
      window.location.replace('/');
    })
    .error(function(data, status){
      $scope.signupError = true;
      $scope.signupErrorMsg = data;
    });
  };  
}]);

app.directive('autoFillSync', ['$timeout', function($timeout){
  return {
    link: function(scope, elem, attrs){
      $timeout(function(){
        elem.trigger('input');
      }, 500);
    }
  }
}]);

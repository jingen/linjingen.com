//= require angular-file-upload
//= require_self
//= require home_controller
var app = angular.module('jl', ["angularFileUpload"]);

app.controller("UserProfile", ["$scope", "$http", "$upload", "$timeout", function($scope, $http, $upload, $timeout){
  $scope.user = {
    email: $('#userEmail').val(),
    password: "",
    password_confirmation: "",
    current_password: ""
  };
  $http.get("/avatar").success(function(data){
    $scope.user.avatar = data.avatar;
  });

  $scope.updateError = false;
  $scope.update = function(){
    $http.put("/users",{
      user: $scope.user
    }).success(function(data, status){
      $scope.updateSuccess = true;
      $timeout(function(){
        $scope.updateSuccess = false;
      }, 2000);
    }).error(function(data, status){
      $scope.updateError = true;
      $scope.updateErrorMsg = data.errors;
    });
  };
  $scope.onFileSelect = function($files) {
    $scope.imageChanging = true;
    $scope.upload = $upload.upload({
      url: '/avatar', 
      data: {email: $scope.user.email},
      file: $files[0],
    }).success(function(data, status, headers, config) {
      $scope.user.avatar = data.avatar;
      $scope.imageChanging = false;
      $('.nav-avatar').attr("src", data.nav_avatar);
    });
  }; 
}]);
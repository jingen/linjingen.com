//= require angular-file-upload
//= require_self
//= require home_controller
var app = angular.module('jl', ["angularFileUpload"]);

app.controller("DocLibrary", ["$scope", "$http", "$upload", function ($scope, $http, $upload) {
  $scope.newDoc = {};
  $scope.onFileSelect = function($files){
    $scope.file = $files[0];
  };
  $scope.addDoc = function(){
    $upload.upload({
      url: '/add_doc',
      data: {document: $scope.newDoc},
      file: $scope.file,
    }).success(function(data, status, headers, config) {
    }).error(function(data,status){});;
  }
}]);
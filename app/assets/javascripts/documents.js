//= require angular-file-upload
//= require_self
//= require home_controller
var app = angular.module('jl', ["angularFileUpload"]);

app.controller("DocLibrary", ["$scope", "$http", "$upload", function ($scope, $http, $upload) {

  $http.get("/public_docs").success(function(data, status){
    $scope.public_docs = data;
  });


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
      $("#documentUpload").modal("hide");
    }).error(function(data,status){});;
  };

}]);
//= require angular-file-upload
//= require_self
//= require home_controller
var app = angular.module('jl', ["angularFileUpload"]);
app.service('publicDocs', ['$http', function($http){
  this.getPublicDocs = function(){
   return $http.get("/public_docs"); 
  }
}]);
app.controller("DocLibrary", ["$scope", "$http", "$upload", "publicDocs", function ($scope, $http, $upload, publicDocs) {

  var fetchData = function(){
    publicDocs.getPublicDocs().success(function(data, status){
      $scope.public_docs = data;
    })
  };
  fetchData();

  $scope.readyUpload = false;

  $scope.readyCheck = function(){
    if(!!$scope.file && !!$scope.newDoc.title && !!$scope.newDoc.description){
      $scope.readyUpload = true;
    }else{
      $scope.readyUpload = false;
    }
  };

  $scope.newDoc = {};
  $scope.onFileSelect = function($files){
    $scope.file = $files[0];
    $scope.readyCheck();
  };
  var documentUpload = $("#documentUpload");
  $scope.addDoc = function(){
    $upload.upload({
      url: '/add_doc',
      data: {document: $scope.newDoc},
      file: $scope.file,
    }).success(function(data, status, headers, config) {
      documentUpload.modal("hide");
      fetchData();
    }).error(function(data,status){});;
  };

  $scope.docView = function(doc){
    console.log(doc);
  }

}]);
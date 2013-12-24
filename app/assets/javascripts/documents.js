//= require angular-file-upload
//= require_self
//= require home_controller
var app = angular.module('jl', ["angularFileUpload"]);
app.service('publicDocs', ['$http', function($http){
  this.getPublicDocs = function(){
   return $http.get("/public_docs"); 
  }
}]);
app.service('userDocs', ['$http', function($http){
  this.getUserDocs = function(){
   return $http.get("/user_docs"); 
  }
}]);
app.service('crocodocSession', ['$http', function($http){
  this.get_session = function(croc_uuid){
    return $http.get("/documents/"+croc_uuid);
  }
}]);
app.controller("DocLibrary", ["$scope", "$http", "$upload", "userDocs", "publicDocs", "crocodocSession", function ($scope, $http, $upload, userDocs, publicDocs, crocodocSession) {

  var fetchPublicData = function(){
    publicDocs.getPublicDocs().success(function(data, status){
      $scope.publicLibDocs = data;
    }).error(function(data, status){});
  };

  var fetchUserData = function(){
    userDocs.getUserDocs().success(function(data, status){
      $scope.userLibDocs = data;
    }).error(function(data, status){
    });
  };

  var fetchData = function(){
    fetchPublicData();
    fetchUserData();
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

  var documentUpload = $("#documentUpload"),
      docFile = $("#documentUpload .fileinput");
  var resetUploadForm = function(){
      $scope.file = "";
      $scope.newDoc = {};
      docFile.fileinput("clear");
  };
  $scope.addDoc = function(){
    $upload.upload({
      url: '/add_doc',
      data: {document: $scope.newDoc},
      file: $scope.file,
    }).success(function(data, status, headers, config) {
      documentUpload.modal("hide");
      fetchData();
      resetUploadForm();
    }).error(function(data,status){});;
  };

  var documentView = $("#documentView");
  $scope.viewDoc = {};
  $scope.docView = function(doc){
    $scope.viewDoc = doc;
    crocodocSession.get_session(doc.croc_uuid).success(function(data, status){
      $scope.viewDoc.view_url = data.view_url;
    });
    documentView.modal("show");
  };

}]);

$(function(){
  var searchBtn = $("#searchBtn"),
      searchBar = $('#searchBar');

  searchBtn.on('click', function(e){
    searchBar.focus();
  });
});
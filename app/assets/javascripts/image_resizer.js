//= require angular-file-upload
//= require_self
//= require home_controller

var app = angular.module('jl', ["angularFileUpload"]);

// image generating service
app.factory('Image', function(){
  return {
    resize_method: "free"
  };
});

// build controller fo image resizing
app.controller('ImageResize', ['$scope', '$http', '$upload', 'Image',  function($scope, $http, $upload, Image){

  $scope.image = Image;
  $scope.resize = function(){
    console.log($scope.image);
    $http.post("/image_resize", {
      image: $scope.image
    }).success(function(data,status){
      $scope.resized_image_url = data.url;
    }).error(function(data, status){

    });
  };

}]);



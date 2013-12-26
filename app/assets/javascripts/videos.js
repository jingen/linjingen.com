//= require_self
//= require home_controller
var app = angular.module('jl', []);

app.controller("VideoLibrary", ["$scope","$http", function($scope, $http){
  // function escapeRegExp(string){
  //   return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
  // }
  var youtubeRegex = new RegExp('.*youtube\\.com.*\\?v=.{11}', 'i');
  var vimeoRegex = new RegExp('.*vimeo\\.com.*\\/\\d+', 'i');
  $scope.fetchVideo = function(){
    if(youtubeRegex.test($scope.videoLink) || vimeoRegex.test($scope.videoLink)){
      console.log($scope.videoLink);
    }
  };
}]);

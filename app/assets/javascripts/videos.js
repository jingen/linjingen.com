//= require_self
//= require home_controller
var app = angular.module('jl', []);

app.service("processVideoLink", ["$http", function($http){
  this.process = function(vLink){
    return $http.post("/process_video_link", {video_link: vLink });
  }
}]);
app.controller("VideoLibrary", ["$scope","$http", "processVideoLink", function($scope, $http, processVideoLink){
  var youtubeRegex = new RegExp('.*youtube\\.com.*\\?v=.{11}', 'i');
  var vimeoRegex = new RegExp('.*vimeo\\.com.*\\/\\d+', 'i');
  $scope.fetchVideo = function(){
    if(youtubeRegex.test($scope.videoLink) || vimeoRegex.test($scope.videoLink)){
      processVideoLink.process($scope.videoLink).success(function(data, status){
        $scope.processingVideo = data;
      }).error(function(data,status) {});
    }
  };
}]);

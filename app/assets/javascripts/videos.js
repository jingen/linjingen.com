//= require_self
//= require home_controller
var app = angular.module('jl', []);

app.service("processVideoLink", ["$http", function($http){
  this.process = function(vLink){
    return $http.post("/process_video_link", {video_link: vLink });
  }
}]);
app.service('publicVideos', ['$http', function($http){
  this.getPublicVideos = function(){
   return $http.get("/public_videos"); 
  }
}]);
app.service('userVideos', ['$http', function($http){
  this.getUserVideos = function(){
   return $http.get("/user_videos"); 
  }
}]);
app.controller("VideoLibrary", ["$scope","$http", "$timeout", "processVideoLink", "publicVideos", "userVideos", function($scope, $http, $timeout, processVideoLink, publicVideos, userVideos){

  var fetchPublicData = function(){
    publicVideos.getPublicVideos().success(function(data, status){
      $scope.publicLibVideos = data;
    }).error(function(data, status){});
  };

  var fetchUserData = function(){
    userVideos.getUserVideos().success(function(data, status){
      $scope.userLibVideos = data;
      $scope.userLibVideosReady = true;
    }).error(function(data, status){
    });
  };

  var fetchData = function(){
    fetchPublicData();
    fetchUserData();
  };

  fetchData();

  var youtubeRegex = new RegExp('.*youtube\\.com.*\\?v=.{11}', 'i');
  var vimeoRegex = new RegExp('.*vimeo\\.com.*\\/\\d+', 'i');
  $scope.fetchVideo = function(){
    if(youtubeRegex.test($scope.videoLink) || vimeoRegex.test($scope.videoLink)){
      processVideoLink.process($scope.videoLink).success(function(data, status){
        $scope.processingVideo = data;
      }).error(function(data,status) {
        $scope.processingVideo = "";
      });
    }
  };

  var newVideoModal = $("#newVideoModal");
  $scope.newVideo = function(){
    $scope.processingVideo = "";
  };
  $scope.addVideo = function(){
    $scope.processing = true;
    $http.post("/add_video", {
      video: $scope.processingVideo
    }).success(function(data, status){
      newVideoModal.modal("hide");
      fetchData();
      $timeout(function(){
        $scope.processing = false;
      },500);
    }).error(function(data, status){});
  };

  var editVideoModal = $("#editVideoModal");
  $scope.editVideo = function(video){
    $scope.processingVideo = video;
  };
  $scope.updateVideo = function(){
    $scope.processing = true;
    $http.post("/update_video",{
      video: $scope.processingVideo
    }).success(function(data, status){
      editVideoModal.modal("hide");
      fetchData();
      $timeout(function(){
        $scope.processing = false;
      },500);
    }).error(function(data, status){});
  };

  var deleteConfirmModel = $("#deleteConfirmModel");
  $scope.deleteConfirm = function(video){
    $scope.deleteVideoId = video.id
  };
  $scope.deleteVideo = function(){
    deleteConfirmModel.modal("hide");
    $http.post("delete_video", {id: $scope.deleteVideoId})
    .success(function(data, status){
      fetchData();
    }).error(function(data, status){});
  };


  var videoViewModal = $("#videoViewModal");
  $scope.viewVideo = function(video){
    $scope.viewingVideo = video;
    videoViewModal.modal("show");
  };

}]);


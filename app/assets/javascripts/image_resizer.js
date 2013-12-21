//= require angular-file-upload
//= require_self
//= require home_controller

var app = angular.module('jl', ["angularFileUpload"]);

// image generating service
app.factory('Image', function(){
  return {
    new: function(){
      return {
        resize_method: "free"
      };
    }
  };
});

// build controller fo image resizing
app.controller('ImageResize', ['$scope', '$http', '$upload', 'Image', function($scope, $http, $upload, Image){

  $scope.image = Image.new();
  $scope.ready = false;
  $scope.processing = false;
  $scope.resize = function(){
    $scope.ready = false;
    $scope.processing = true;
    if (!!$scope.image.remote_image_url) {
      $http.post("/image_resize", {
        image: $scope.image
      }).success(function(data,status){
        $scope.resized_image_url = data.url;
        $scope.processing = false;
      }).error(function(data, status){});
    } else{
      $upload.upload({
          url: '/image_resize',
          data: {image: $scope.image},
          file: $scope.file,
        }).success(function(data, status, headers, config) {
          $scope.resized_image_url = data.url;
          $scope.processing = false;
        }).error(function(data,status){});;
    };
  };

  // once the user provide image url, desired dimensions, enable the "resize" 
  // button and display "ready" label
  $scope.checkReady = function(){
    var image = $scope.image;
    if(
        ((typeof image.remote_image_url != "undefined" && image.remote_image_url != "") ||
          (typeof $scope.file != "undefined" && $scope.file != null))
        &&
        (
          (
            (typeof image.width != "undefined" && image.width != "") &&
            (typeof image.height != "undefined" && image.height != "")
          ) || 
          (typeof image.scale != "undefined" && image.scale != "")
        )
      ){
      $('#resizeBtn').removeAttr('disabled');
      $scope.ready = true;
    }else{
      $('#resizeBtn').attr('disabled','');
      $scope.ready = false;
    }
  };

  //listening the change of the scale input
  var imageWidth = $('#image-width'),
      imageHeight = $('#image-height'),
      radioFit = $('#radioFit'),
      radioFill = $('#radioFill');
  $scope.scaleChange = function(){
    // users can only enter digits
    $scope.image.scale = $scope.image.scale.replace(/[^0-9]/, '');

    // indicating user if they enter the right data of the width or height
    if (typeof $scope.image.scale != "undefined" && $scope.image.scale != "") {
      $scope.scaleBadge = true;
      if($scope.image.scale > 0){
        $scope.scaleOk = true;
      }else{
        $scope.scaleOk = false;
      }

      $scope.image.resize_method = "free";
      disableWidthHeight();
    }else{
      $scope.scaleBadge = false;
      enableWidthHeight();
    };
    $scope.checkReady();
  };

  var disableWidthHeight = function(){
    imageWidth.attr('disabled', '');
    imageHeight.attr('disabled', '');
    radioFit.attr('disabled','');
    radioFill.attr('disabled','');
  };

  var enableWidthHeight = function(){
    imageWidth.removeAttr('disabled');
    imageHeight.removeAttr('disabled');
    radioFit.removeAttr('disabled');
    radioFill.removeAttr('disabled');
  };

  var imageScale = $('#image-scale');
  var disableScale = function(){
    $scope.image.scale = "";
    imageScale.attr('disabled', '');
  }
  var enableScale = function(){
    imageScale.removeAttr('disabled');
  }
// listening the change of the input of the desired width and the desired height
  $scope.widthChange = function(){
    if(typeof $scope.image.width != "undefined"){
      $scope.image.width = $scope.image.width.replace(/[^0-9]/, '');
      if ($scope.image.width != "") {
        disableScale();
        $scope.widthBadge = true;
        if($scope.image.width > 0){
          $scope.widthOk = true;
        }else{
          $scope.widthOk = false;
        }
      }else{
        enableScale();
        $scope.widthBadge = false;
      }
    }
    $scope.checkReady();
  };

  $scope.heightChange = function(){
    if(typeof $scope.image.height != "undefined"){
      $scope.image.height = $scope.image.height.replace(/[^0-9]/, '');
      if ($scope.image.height != "") {
        disableScale();
        $scope.heightBadge = true;
        if($scope.image.height > 0){
          $scope.heightOk = true;
        }else{
          $scope.heightOk = false;
        }
      }else{
        enableScale();
        $scope.heightBadge = false;
      };
    }
    $scope.checkReady();
  };

  //upload image info is saved to $scope.file
  $scope.onFileSelect = function($files){
    $scope.file = $files[0];
    $scope.checkReady();
  };

  var fileinput = $(".fileinput");
  $scope.clearUpload = function(){
    $scope.file = null; 
    fileinput.fileinput("clear");
    $('#resizeBtn').attr('disabled','');
  };

  $scope.clearURL = function(){
    $scope.image.remote_image_url = "";
    $('#resizeBtn').attr('disabled','');
  };

  var resetBtn = $("#resetBtn");
  $scope.reset = function(){
    fileinput.fileinput("clear");
    enableScale();
    enableWidthHeight()
    $scope.clearURL();
    $scope.widthBadge = false;
    $scope.heightBadge = false;
    $scope.scaleBadge = false;
    $scope.image = Image.new();
    resetBtn.trigger('blur');
  };

}]);



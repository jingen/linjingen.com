//= require angular-file-upload
//= require_self
//= require home_controller
var app = angular.module('jl', []);

// controller for words' spell checking
app.controller('SpellCheck', ['$scope', '$http', function($scope, $http){
  $scope.results = [];
  // ajax, send the users' input to server, server check the input and send back the results and show them on the page.
  $scope.check = function(){
    var words = {
      words: $scope.words
    };
    $http({
      url: '/word_check',
      method: 'post',
      data: words,
      responseType: "json"
    }).success(function(data){
      $scope.results = data;
      if($scope.results.length == 0){
        $scope.noError = true;
      }else{
        $scope.noError = false;
      }
    });
  }
}]);

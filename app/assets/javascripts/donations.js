//= require datepicker
//= require underscore
//= require gmaps/google
//= require_self
//= require home_controller
var app = angular.module('jl', []);

app.service('donationHistory', ['$http', function($http){
  this.getDonations = function(){
   return $http.get("/donation_history"); 
  }
}]);

app.controller("Donation", ['$scope', '$http', '$timeout', 'donationHistory', function($scope, $http, $timeout, donationHistory){
  $scope.donation = {};
  $scope.donate = function(){
    $http.post('create_donation', {"donation":$scope.donation}).success(function(data){
      $scope.donateSuccess = true;
      $scope.fetchDonations();
      $timeout(function(){
        $scope.donateSuccess = false;
      }, 2000);
    });
  };

  $scope.fetchDonations = function(){
    donationHistory.getDonations().success(function(data, status){
      $scope.donations = data;
    }).error(function(data, status){});;
  };

  var showLocation = $("#showLocation");
  $scope.showInMap = function(item){
    $scope.renderGooglemap(item.coordinates);
    showLocation.modal("show");
  }

  $scope.renderGooglemap = function(coordinates){
   handler = Gmaps.build('Google');
   handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
    markers = handler.addMarkers([
    {
      "lat": coordinates[1],
      "lng": coordinates[0]
    }
    ]);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    handler.getMap().setZoom(13);
  });
 };

  $scope.fetchDonations();
}]);

app.directive('donationDate', function(){
  return{
    restrict: 'A',
    link: function(scope, elem, attr, ctrl){
      elem.datepicker({
        todayHighlight: true,
        autoclose: true,
        format: "yyyy-mm-dd"
      }).on("changeDate", function(e){
        scope.$apply(function(){
          if(e.currentTarget.id == "expirationDate"){
            scope.donation.expiration_date= e.format("yyyy-mm-dd");
          }
        });
      });
    }
  };
});

$(function(){
  $('#showLocation').on('shown.bs.modal', function () {
    google.maps.event.trigger(map, "resize");
  });
});

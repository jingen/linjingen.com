//= require_self
//= require home_controller
var app = angular.module('jl', []);
$(document).ready(function(){ 
  $('.carousel').carousel({interval: 17666});
  
  $(window).scroll(function(){
    if ($(this).scrollTop() > 100) {
      $('.scrollup').fadeIn();
    } else {
      $('.scrollup').fadeOut();
    }
  }); 
  $("html, body").scrollTop(0);
  $('.scrollup').click(function(){
    $("html, body").animate({ scrollTop: 0 }, 600);
    return false;
  });
});


//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require pirobox_extended_min
//= require ./design/all

$(document).ready(function() {
  $('div.information > div.profile > a').live('click', function(e) {
      e.preventDefault();
  });
});
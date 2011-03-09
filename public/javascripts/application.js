// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
        setTimeout(hideFlashes, 2000);
});

var hideFlashes = function() {
  $("#flash_notice, #flash_error").fadeOut(4000);
}
$(document).ready(function() {
  
  $('#activity-menu a').click(function() {
    $('#activity-menu .active').removeClass('active');
    $(this).parent().addClass('active');    
    var url = $(this).attr('href');   
    $('#activities').fadeOut();
    $.get(url, function(data) {   
      $('#activities').html(data).fadeIn();  
    });               
    
    return false;
  });
});
